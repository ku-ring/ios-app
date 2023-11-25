//
//  NoticeList.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/22.
//

import Model
import SwiftUI
import Network
import ComposableArchitecture

struct NoticeListFeature: Reducer {
    struct State: Equatable {
        var notices: IdentifiedArrayOf<Notice> = []
        
        var currentNoticeType: NoticeType = .학과
        var currentDepartment: NoticeProvider? = NoticeProvider.departments[0] // 기본값은 addedDepartment의 첫번째 값
        
        @PresentationState var changeDepartment: DepartmentSelectorFeature.State?
        
        /// 공지
        var noticeDictionary: [NoticeType: NoticeInfo] = [:]
        
        struct NoticeInfo: Equatable {
            /// 공지
            var notices: [Notice] = []
            /// 공지 페이지
            var page: Int = 0
            /// 공지를 더 가져올 수 있는지 여부
            var hasNextList: Bool = true
            /// 한번 요청 시 가져올 수 있는 공지 사항 개수 최댓값
            let loadLimit = 20
        }
    }
    
    enum Action {
        /// 학과 변경하기 버튼을 탭한 경우
        case changeDepartmentButtonTapped
        
        /// 공지 카테고리 세그먼트를 탭한 경우
        /// - Parameter noticeType: 선택한 공지 카테고리.
        case noticeTypeSegmentTapped(NoticeType)
        
        /// ``DepartmentSelectorFeature`` 의 Presentation 액션
        case changeDepartment(PresentationAction<DepartmentSelectorFeature.Action>)
        
        /// ``NoticeAppFeature`` 으로 액션을 전달하기 위한 델리게이트
        case delegate(Delegate)
        
        /// 공지를 가져오기 위한 네트워크 요청을 하는 경우
        case fetchNotices
        
        /// 네트워크 요청에 대한 응답을 받은 경우
        case responseNotices(TaskResult<(NoticeType, [Notice])>)
        
        /// 북마크 버튼을 탭한 경우
        /// - Parameter notice: 북마크 액션 대상인 공지
        case bookmarkTapped(Notice)
        
        /// ``NoticeAppFeature`` 에 전달 될 액션 종류
        enum Delegate {
            /// 학과 편집 버튼을 선택한 경우
            case editDepartment
        }
    }
    
    @Dependency(\.kuringLink) var kuringLink
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .changeDepartmentButtonTapped:
                state.changeDepartment = DepartmentSelectorFeature.State(
                    currentDepartment: state.currentDepartment,
                    addedDepartment: IdentifiedArray(uniqueElements: NoticeProvider.departments) // TODO: Dependency
                )
                return .none
                
            case let .noticeTypeSegmentTapped(noticeType):
                if state.currentNoticeType != noticeType {
                    state.currentNoticeType = noticeType
                    
                    return .run { send in
                        await send(.fetchNotices)
                    }
                } else {
                    return .none
                }
                
            case let .changeDepartment(.presented(.delegate(delegate))):
                switch delegate {
                case .editDepartment:
                    state.changeDepartment = nil
                    return .send(.delegate(.editDepartment))
                }
                
                // TODO: Delegate
            case .delegate:
                return .none
                
            case .changeDepartment(.presented(.selectDepartment)):
                /// ``DepartmentSelectorFeature`` 액션
                guard let selectedDepartment = state.changeDepartment?.currentDepartment else {
                    return .none
                }
                state.currentDepartment = selectedDepartment
                return .none
            
            case .changeDepartment:
                return .none

            case .fetchNotices:
                let currentNoticeType = state.currentNoticeType
                let currentDepartment = state.currentDepartment
                let noticeDictionary = state.noticeDictionary
                
                return .run { 
                    [
                        currentNoticeType = currentNoticeType,
                        currentDepartment = currentDepartment,
                        noticeDictionary = noticeDictionary
                    ] send in
                    
                    var noticeInfo = noticeDictionary[currentNoticeType]
                    if noticeInfo == nil { noticeInfo = State.NoticeInfo() }
                    
                    var departmentHostPrefix: String? = nil
                    if currentNoticeType == .학과 && currentDepartment != nil {
                        departmentHostPrefix = currentDepartment?.hostPrefix
                    }
                    do {
                        let notices = try await kuringLink.fetchNotices(
                            noticeInfo?.loadLimit ?? 20,
                            currentNoticeType.shortStringValue,
                            departmentHostPrefix,
                            noticeInfo?.page ?? 0
                        )
                        await send(.responseNotices(.success((currentNoticeType, notices))))
                    } catch {
                        await send(.responseNotices(.failure(error)))
                    }
                }
                
            case let .responseNotices(.success((noticeType, notices))):
                if state.noticeDictionary[noticeType] == nil {
                    state.noticeDictionary[noticeType] = State.NoticeInfo()
                }
                guard var noticeInfo = state.noticeDictionary[noticeType] else { return .none }
                
                noticeInfo.hasNextList = notices.count >= noticeInfo.loadLimit
                noticeInfo.page += 1
                noticeInfo.notices += notices
                
                state.noticeDictionary[noticeType] = noticeInfo
                
                return .none
            
            case let .responseNotices(.failure(error)):
                
                return .none
            
            case let .bookmarkTapped(notice):
                return .none
            }
        }
        .ifLet(\.$changeDepartment, action: /Action.changeDepartment) {
            DepartmentSelectorFeature()
        }
    }
    
    func save() { }
}

struct NoticeList: View {
    let store: StoreOf<NoticeListFeature>
    
    /// - NOTE: NoticeList 만 제외하고 나머지는 NotiecApp 단으로 옮겨야 하는가?
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                // 공지 카테고리 리스트
                NoticeTypeGrid(store: self.store)
                    .frame(height: 48)
                    .onAppear {
                        print("on Appear")
                        viewStore.send(.fetchNotices)
                    }
                
                switch viewStore.currentNoticeType {
                case .학과:
                    // 학과공지
                    if let currentDepartment = viewStore.currentDepartment ?? NoticeProvider.departments.first {
                        Section {
                            let noticeInfo = viewStore.noticeDictionary[.국제] // viewStore.noticeDictionary[currentDepartment]
                            noticeList(noticeInfo?.notices ?? [])
                        } header: {
                            DepartmentSelectorLink(department: currentDepartment) {
                                viewStore.send(.changeDepartmentButtonTapped)
                            }
                        }
                    } else {
                        NoDepartmentView()
                    }
                    
                default:
                    // 대학공지
                    let noticeType = viewStore.currentNoticeType
                    let notices = viewStore.noticeDictionary[noticeType]?.notices
                    noticeList(notices ?? [])

                    Spacer()
                }
                
            }
        }
        .sheet(
            store: self.store.scope(
                state: \.$changeDepartment,
                action: { .changeDepartment($0) }
            )
        ) { store in
            NavigationStack {
                DepartmentSelector(store: store)
                    .navigationTitle("Department Selector")
            }
        }
    }
    
    
    
    /// 공지 리스트
    @ViewBuilder
    private func noticeList(_ notices: [Notice]) -> some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List(notices, id: \.id) { notice in
                NavigationLink(
                    state: NoticeAppFeature.Path.State.detail(
                        NoticeDetailFeature.State(notice: notice)
                    )
                ) {
                    NoticeRow(notice: notice)
                        .listRowInsets(EdgeInsets())
                        .onAppear {
                            let type = viewStore.currentNoticeType
                            let noticeInfo = viewStore.noticeDictionary[type]
                            
                            /// 마지막 공지가 보이면 update
                            if noticeInfo?.notices.last == notice {
                                viewStore.send(.fetchNotices)
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                viewStore.send(.bookmarkTapped(notice))
                            } label: {
                                Image(systemName: "bookmark.slash")
                                // Image(systemName: isBookmark ? "bookmark.slash" : "bookmark")
                            }
                            .tint(Color.accentColor)
                        }
                }
            }
            .listStyle(.plain)
        }
        
    }
}

#Preview {
    NavigationStack {
        NoticeList(
            store: Store(
                initialState: NoticeListFeature.State(),
                reducer: { NoticeListFeature() }
            )
        )
    }
}
