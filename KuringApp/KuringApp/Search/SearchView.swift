//
//  SearchView.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/22.
//

import Model
import SwiftUI
import ComposableArchitecture

struct SearchFeature: Reducer {
    struct State: Equatable {
        var recents: [String] = []
        var results: [String]? = nil
        
        var resultNotices: [Notice]? = nil
        var resultStaffs: [Staff]? = nil
        
        @BindingState var searchInfo: SearchInfo = SearchInfo()
        @BindingState var focus: Field? = .search
        
        struct SearchInfo: Equatable {
            var text: String = ""
            var searchType: SearchType = .notice

            var noticeSearchPhase: SearchPhase = .before
            var staffSearchPhase: SearchPhase = .before
            
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
                /// 검색 완료 (결과가 없는 상태)
                case completeNoResult
                /// 검색 실패
                case failure
            }
        }
        
        enum Field {
            case search
        }
    }
    
    enum Action: BindableAction {
        /// 최근 검색어 전체 삭제
        case deleteAllRecentsButtonTapped
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .binding(\.$searchInfo):
                return .none
                
            case .deleteAllRecentsButtonTapped:
                state.recents.removeAll()
                return .none
                
            }
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
                    HStack(alignment: .center, spacing: 12) {
                        if viewStore.searchInfo.text.isEmpty {
                            Image(systemName: "magnifyingglass")
                                .frame(width: 16, height: 16)
                                .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                        }
                        
                        TextField("검색어를 입력해주세요", text: viewStore.$searchInfo.text)
                            .focused($focus, equals: .search)
                        
                        if viewStore.searchInfo.text.isEmpty {
                            Image(systemName: "xmark")
                                .frame(width: 16, height: 16)
                                .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 7)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                    .cornerRadius(20)
                }
                
                if !viewStore.recents.isEmpty {
                    HStack {
                        Text("최근검색어")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                        Spacer()
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
                    
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(viewStore.recents, id: \.self) { recent in
                                HStack(alignment: .center, spacing: 6) {
                                    Button {
                                        // TODO: 검색
                                    } label: {
                                        Text(recent)
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color(red: 0.24, green: 0.74, blue: 0.5))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                            .background(Color(red: 0.24, green: 0.74, blue: 0.5).opacity(0.1))
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
                        .foregroundColor(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                        .padding(.top, 20)
                        .padding(.bottom, 12)
                    
                    Spacer()
                }
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                    .cornerRadius(10)
                    .overlay {
                        switch viewStore.searchInfo.searchType {
                        case .notice:
                            HStack {
                                segmentView("공지", isSelect: true)
                                
                                Button {
                                    let type = SearchFeature.State.SearchInfo(searchType: .staff)
                                    viewStore.send(.binding(.set(\.$searchInfo, type)))
                                } label: {
                                    segmentView("교직원", isSelect: false)
                                }
                            }
                            .padding(5)
                            
                        case .staff:
                            HStack {
                                Button {
                                    let type = SearchFeature.State.SearchInfo(searchType: .notice)
                                    viewStore.send(.binding(.set(\.$searchInfo, type)))
                                } label: {
                                    segmentView("공지", isSelect: false)
                                }
                                
                                segmentView("교직원", isSelect: true)
                            }
                            .padding(5)
                        }
                    }
                
                switch viewStore.searchInfo.searchType {
                case .notice:
                    if let notices = viewStore.resultNotices {
                        if notices.isEmpty {
                            feedbackPhaseView
                        } else {
                            List(notices, id: \.self) { notice in
                                // TODO: - 디자인 시스템 NoticeRow
                                Text("NoticeRow 적용하기")
                            }
                        }
                    } else {
                        emptyPhaseView(viewStore.searchInfo.noticeSearchPhase)
                    }
                case .staff:
                    if let staffs = viewStore.resultStaffs {
                        if staffs.isEmpty {
                            feedbackPhaseView
                        } else {
                            List(staffs, id: \.self) { staff in
                                Button {
                                    // TODO: -
                                } label: {
                                    StaffRow(staff: staff)
                                }
                            }
                        }
                    } else {
                        emptyPhaseView(viewStore.searchInfo.noticeSearchPhase)
                    }
                }
                
            }
            .padding(.horizontal, 20)
            .bind(viewStore.$focus, to: self.$focus)
        }
    }
    
    @ViewBuilder
    private func segmentView(_ title: String, isSelect: Bool) -> some View {
        if isSelect {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 0)
                .overlay {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color(red: 0.24, green: 0.74, blue: 0.5))
                }
        } else {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.clear)
                .overlay {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                }
        }
    }
    
    @ViewBuilder
    private func emptyPhaseView(_ phase: SearchFeature.State.SearchInfo.SearchPhase) -> some View {
        switch phase {
        case .before:
            beforePhaseView
        case .searching:
            searchingPhaseView
        case .complete, .completeNoResult, .failure:
            feedbackPhaseView
        }
    }
    
    @ViewBuilder
    private var beforePhaseView: some View {
        VStack {
            Group {
                Text("쿠링에서는 원하는 공지와 교직원을 한눈에")
                Text("최고의 알고리즘으로 원하는 결과를 빠르게 찾아드려요.")
            }
            .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.56))
            .font(.system(size: 16))
                
            Spacer()
        }
        .padding(.top, 72)
    }
    
    @ViewBuilder
    private var feedbackPhaseView: some View {
        VStack {
            Group {
                Text("찾은 결과가 없어요.")
                Text("검색에 문제가 있는 것 같다면 피드백을 보내주세요.")
                Text("보내주신 피드백은 글자 한 톨까지 꼼꼼하게 쿠링팀이 살펴볼게요.")
            }
            .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.56))
            .font(.system(size: 12))
            
            Button {
                // TODO: 피드백
            } label: {
                RoundedRectangle(cornerRadius: 100)
                    .foregroundStyle(Color(red: 0.24, green: 0.74, blue: 0.5).opacity(0.15))
                    .frame(height: 50)
                    .overlay {
                        Text("피드백 보내기")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(red: 0.24, green: 0.74, blue: 0.5))
                    }
            }
            .padding(.top, 36)
            
            Spacer()
        }
        .padding(.top, 72)
    }
    
    @ViewBuilder
    private var searchingPhaseView: some View {
        VStack {
            Text("검색중...")
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
