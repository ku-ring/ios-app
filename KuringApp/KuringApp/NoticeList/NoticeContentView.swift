//
//  NoticeContentView.swift
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
        // MARK: 네비게이션
        @PresentationState var changeDepartment: DepartmentSelectorFeature.State?
        
        /// 현재 공지리스트를 제공하는 `NoticeProvider` 값
        ///
        /// - IMPORTANT: 추가한 학과가 있으면 추가한 학과의 첫번째 값이 초기값으로 세팅되고 없으면 `.학사`
        var provider: NoticeProvider = NoticeProvider.departments.first ?? NoticeProvider.학사
        
        
        /// 공지
        var noticeDictionary: [NoticeProvider: NoticeInfo] = [:]
        
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
        case responseNotices(TaskResult<(NoticeProvider, [Notice])>)
        
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
                    currentDepartment: state.provider,
                    addedDepartment: IdentifiedArray(uniqueElements: NoticeProvider.departments) // TODO: Dependency
                )
                return .none
                
            case let .noticeTypeSegmentTapped(noticeType):
                let provider = noticeType.provider
                guard provider.id != state.provider.id else {
                    return .none
                }
                state.provider = provider
                return .run { send in
                    await send(.fetchNotices)
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
                state.provider = selectedDepartment
                return .none
                
            case .changeDepartment(.dismiss):
                return .run { send in
                    await send(.fetchNotices)
                }
            
            case .changeDepartment:
                return .none

            case .fetchNotices:
                if state.provider == .emptyDepartment {
                    return .none
                }
                return .run { [provider = state.provider, noticeDictionary = state.noticeDictionary] send in
                    let retrievalInfo = noticeDictionary[provider] ?? State.NoticeInfo()
                    
                    let department: String? = if provider.category == .학과 {
                        provider.hostPrefix
                    } else {
                        nil
                    }
                    
                    do {
                        let notices = try await kuringLink.fetchNotices(
                            retrievalInfo.loadLimit,
                            provider.category == .학과 ? "dep" : provider.hostPrefix, // TODO: korean name 도 쓸 거 고려해서 문자열 말고 좀 더 나은걸로
                            department,
                            retrievalInfo.page
                        )
                        await send(.responseNotices(.success((provider, notices))))
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
                print(error.localizedDescription)
                return .none
            
            case let .bookmarkTapped(notice):
                print("공지#\(notice.articleId)을 북마크 했습니다.")
                return .none
            }
        }
        .ifLet(\.$changeDepartment, action: /Action.changeDepartment) {
            DepartmentSelectorFeature()
        }
    }
    
    func save() { }
}

struct NoticeContentView: View {
    let store: StoreOf<NoticeListFeature>
    
    /// - NOTE: NoticeList 만 제외하고 나머지는 NotiecApp 단으로 옮겨야 하는가?
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                // 공지 카테고리 리스트
                NoticeTypePicker(store: self.store)
                    .frame(height: 48)
                    .onAppear {
                        print("on Appear")
                        viewStore.send(.fetchNotices)
                    }
                
                if viewStore.provider == .emptyDepartment {
                    NoDepartmentView()
                } else {
                    NoticeList(store: self.store)
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
}

#Preview {
    NavigationStack {
        NoticeContentView(
            store: Store(
                initialState: NoticeListFeature.State(),
                reducer: { NoticeListFeature() }
            )
        )
    }
}
