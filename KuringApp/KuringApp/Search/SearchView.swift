//
//  SearchView.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/22.
//

import SwiftUI
import ComposableArchitecture

struct SearchFeature: Reducer {
    struct State: Equatable {
        var recents: [String] = []
        var results: [String]? = nil
        @BindingState var searchInfo: SearchInfo = SearchInfo()
        @BindingState var focus: Field? = .search
        
        struct SearchInfo: Equatable {
            var text: String = ""
            var searchType: SearchType = .notice
            
            enum SearchType: String {
                case notice
                case staff
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
            List {
                TextField("검색어를 입력해주세요", text: viewStore.$searchInfo.text)
                    .focused($focus, equals: .search)
                
                Picker("어떤 것을 검색하시나요?", selection: viewStore.$searchInfo.searchType) {
                    Text("공지")
                        .tag(SearchFeature.State.SearchInfo.SearchType.notice)
                    
                    Text("교직원")
                        .tag(SearchFeature.State.SearchInfo.SearchType.staff)
                }
                .pickerStyle(.segmented)
                
                Section {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(viewStore.recents, id: \.self) { recent in
                                Button(recent) {
                                    
                                }
                            }
                        }
                    }
                    
                    Button("전체 삭제") {
                        viewStore.send(.deleteAllRecentsButtonTapped)
                    }
                    .tint(.pink)
                } header: {
                    Text("최근 검색어")
                }
                
                Section {
                    Text(viewStore.searchInfo.text)
                    
                    Text(viewStore.searchInfo.searchType.rawValue)
                } header: {
                    Text("검색 정보")
                }
                
                Section {
                    if viewStore.results?.isEmpty == true {
                        Text("검색결과가 없어요")
                    }
                }
            }
            .bind(viewStore.$focus, to: self.$focus)
            .navigationTitle("Search View")
        }
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
    }
}
