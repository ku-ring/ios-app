//
//  SearchView.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/22.
//

import Model
import SwiftUI
import KuringDependencies
import ComposableArchitecture

struct SearchFeature: Reducer {
    struct State: Equatable {
        @PresentationState var staffDetail: StaffDetailFeature.State?
        
        var recents: [String] = []
        
        var resultNotices: [Notice]? = nil
        var resultStaffs: [Staff]? = nil
        
        @BindingState var searchInfo: SearchInfo = SearchInfo()
        @BindingState var focus: Field? = .search
        
        struct SearchInfo: Equatable {
            var text: String = ""
            var searchType: SearchType = .notice
            var searchPhase: SearchPhase = .before
            
            enum SearchType: String {
                case notice
                case staff
            }
            
            enum SearchPhase {
                /// 검색 시작 전 (API 요청 전 상태)
                case before
                /// 검색 중 (API 응답을 기다리는 상태)
                case searching
                /// 검색 완료 (결과가 있는 상태)
                case complete
                /// 검색 실패
                case failure
            }
        }
        
        enum Field {
            case search
        }
    }
    
    enum Action: BindableAction {
        /// 트리 네비게이션 - ``StaffDetailFeature`` 액션
        case staffDetail(PresentationAction<StaffDetailFeature.Action>)
        /// 최근 검색어 전체 삭제
        case deleteAllRecentsButtonTapped
        /// 검색어 제거
        case clearKeywordButtonTapped
        /// 검색
        case search
        /// 검색 결과
        case searchResponse(Result<SearchResult, SearchError>)
        /// 최근 검색어 선택. associated value 는 최근 검색어.
        case recentSearchKeywordTapped(String)
        /// ``StaffRow`` 선택
        case staffRowSelected(Staff)
        
        case binding(BindingAction<State>)
        
        enum SearchResult {
            case notices([Notice])
            case staffs([Staff])
        }
    }
    
    enum SearchError: Error {
        case notice(Error)
        case staff(Error)
    }
    
    @Dependency(\.kuringLink) var kuringLink
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .deleteAllRecentsButtonTapped:
                state.recents.removeAll()
                return .none
                
            case .clearKeywordButtonTapped:
                state.searchInfo.text = ""
                return .none
            
            case .search:
                guard !state.searchInfo.text.isEmpty else { return .none }
                
                state.focus = nil
                
                // 최근 검색어 추가
                if !state.recents.contains(state.searchInfo.text) { // 중복체크
                    state.recents.append(state.searchInfo.text)
                }
                
                state.searchInfo.searchPhase = .searching
                switch state.searchInfo.searchType {
                case .notice:
                    return .run { [keyword = state.searchInfo.text] send in
                        let notices = try await kuringLink.searchNotices(keyword)
                        await send(.searchResponse(.success(.notices(notices))))
                    } catch: { error, send in
                        await send(.searchResponse(.failure(SearchError.notice(error))))
                    }
                case .staff:
                    return .run { [keyword = state.searchInfo.text] send in
                        let staffs = try await kuringLink.searchStaffs(keyword)
                        await send(.searchResponse(.success(.staffs(staffs))))
                    } catch: { error, send in
                        await send(.searchResponse(.failure(SearchError.staff(error))))
                    }
                }
                
            case let .recentSearchKeywordTapped(keyword):
                state.searchInfo.text = keyword
                return .send(.search)
                
            case let .searchResponse(.success(results)):
                switch results {
                case let .notices(values):
                    state.resultNotices = values
                    
                case let .staffs(values):
                    state.resultStaffs = values
                }
                state.searchInfo.searchPhase = .complete
                return .none
                
            case let .searchResponse(.failure(searchError)):
                switch searchError {
                case let .notice(error):
                    print(error.localizedDescription)
                    state.resultNotices = nil
                    
                case let .staff(error):
                    print(error.localizedDescription)
                    state.resultStaffs = nil
                }
                state.searchInfo.searchPhase = .failure
                return .none
                
            case let .staffRowSelected(staff):
                state.staffDetail = StaffDetailFeature.State(staff: staff)
                return .none
                
            case .staffDetail(.dismiss):
                state.staffDetail = nil
                return .none
                
            case .staffDetail:
                return .none
            }
        }
        .ifLet(\.$staffDetail, action: /Action.staffDetail) {
            StaffDetailFeature()
        }
    }
}

struct SearchView: View {
    let store: StoreOf<SearchFeature>
    @FocusState var focus: SearchFeature.State.Field?
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                ZStack {
                    /// 검색창
                    HStack(alignment: .center, spacing: 12) {
                        /// 검색 아이콘
                        Image(systemName: "magnifyingglass")
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.caption1.opacity(0.6))
                        
                        TextField("검색어를 입력해주세요", text: viewStore.$searchInfo.text)
                            .focused($focus, equals: .search)
                            .onSubmit { viewStore.send(.search) }
                        
                        if viewStore.searchInfo.searchPhase == .searching {
                            /// 검색 중 로딩 인디케이터
                            ProgressView()
                        } else {
                            if !viewStore.searchInfo.text.isEmpty {
                                /// 검색어 삭제 버튼
                                Button {
                                    viewStore.send(.clearKeywordButtonTapped)
                                } label: {
                                    Image(systemName: "xmark")
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(Color.caption1.opacity(0.6))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 7)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                    .cornerRadius(20)
                }
                
                if !viewStore.recents.isEmpty {
                    HStack {
                        /// 최근 검색어
                        Text("최근검색어")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.caption1.opacity(0.6))
                        
                        Spacer()
                        
                        /// 전체 삭제
                        Button {
                            viewStore.send(.deleteAllRecentsButtonTapped)
                        } label: {
                            Text("전체삭제")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.56))
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 12)
                    
                    /// 최근 검색어 목록
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(viewStore.recents, id: \.self) { recent in
                                HStack(alignment: .center, spacing: 6) {
                                    Button {
                                        viewStore.send(.recentSearchKeywordTapped(recent))
                                    } label: {
                                        Text(recent)
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color.accentColor)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                            .background(Color.accentColor.opacity(0.1))
                                            .cornerRadius(20)
                                    }
                                }
                                
                            }
                        }
                    }
                    .frame(height: 30)
                }
                
                HStack {
                    Text("검색결과")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.caption1.opacity(0.6))
                        .padding(.top, 20)
                        .padding(.bottom, 12)
                    
                    Spacer()
                }
                
                /// 검색타입 세그먼트
                Rectangle()
                    .foregroundStyle(Color.clear)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                    .cornerRadius(10)
                    .overlay {
                        HStack {
                            Button {
                                let type = SearchFeature.State.SearchInfo(searchType: .notice)
                                viewStore.send(.binding(.set(\.$searchInfo, type)))
                            } label: {
                                SegmentView("공지", isSelect: viewStore.searchInfo.searchType == .notice)
                            }
                            
                            Button {
                                let type = SearchFeature.State.SearchInfo(searchType: .staff)
                                viewStore.send(.binding(.set(\.$searchInfo, type)))
                            } label: {
                                SegmentView("교직원", isSelect: viewStore.searchInfo.searchType == .staff)
                            }
                        }
                        .padding(5)
                    }
                
                /// 검색결과
                switch viewStore.searchInfo.searchType {
                case .notice:
                    if let notices = viewStore.resultNotices, !notices.isEmpty {
                        List(notices, id: \.self) { notice in
                            NavigationLink(
                                state: NoticeAppFeature.Path.State.detail(
                                    NoticeDetailFeature.State(notice: notice)
                                )
                            ) {
                                VStack(alignment: .leading) {
                                    Text(notice.subject)
                                    
                                    HStack {
                                        Text(notice.postedDate)
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                    } else {
                        beforePhaseView
                    }
                case .staff:
                    if let staffs = viewStore.resultStaffs, !staffs.isEmpty {
                        List(staffs, id: \.self) { staff in
                            Button {
                                viewStore.send(.staffRowSelected(staff))
                            } label: {
                                StaffRow(staff: staff)
                            }
                            .buttonStyle(.plain)
                        }
                        .listStyle(.plain)
                    } else {
                        beforePhaseView
                    }
                }
                
            }
            .padding(.horizontal, 20)
            .bind(viewStore.$focus, to: self.$focus)
        }
        .sheet(
            store: self.store.scope(
                state: \.$staffDetail,
                action: { .staffDetail($0) }
            )
        ) { store in
            StaffDetailView(store: store)
                .presentationDetents([.medium])
        }
    }
    
    @ViewBuilder
    private func SegmentView(_ title: String, isSelect: Bool) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(isSelect ? Color.white : Color.clear)
            .shadow(
                color: .black.opacity(isSelect ? 0.1 : 0),
                radius: 6, x: 0, y: 0
            )
            .overlay {
                Text(title)
                    .font(.system(size: 16, weight: isSelect ? .bold : .medium))
                    .foregroundStyle(
                        isSelect 
                        ? Color.accentColor
                        : Color.caption1.opacity(0.6)
                    )
            }
    }
    
    @ViewBuilder
    private var beforePhaseView: some View {
        VStack {
            Group {
                Text("검색 결과가 없어요")
            }
            .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.56))
            .font(.system(size: 16))
                
            Spacer()
        }
        .padding(.top, 72)
    }
}

#Preview {
    NavigationStack {
        SearchView(
            store: Store(
                initialState: SearchFeature.State(recents: ["방학", "운송수단", "운임표"]),
                reducer: { SearchFeature() }
            )
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Search View")
    }
}
