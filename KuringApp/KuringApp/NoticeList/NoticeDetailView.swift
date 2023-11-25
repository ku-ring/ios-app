//
//  NoticeDetailView.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/22.
//

import Model
import SwiftUI
import ComposableArchitecture

struct NoticeDetailFeature: Reducer {
    struct State: Equatable {
        var notice: Notice
        var isBookmarked: Bool = false
    }
    
    enum Action: Equatable {
        case bookmarkButtonTapped
        
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case bookmarkUpdated(Bool)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .bookmarkButtonTapped:
                state.isBookmarked.toggle()
                return .none
                
            case .delegate:
                return .none
            }
        }
        .onChange(of: \.isBookmarked) { oldValue, newValue in
            Reduce { state, action in
                return .send(.delegate(.bookmarkUpdated(newValue)))
            }
        }
    }
}

struct NoticeDetailView: View {
    let store: StoreOf<NoticeDetailFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List {
                Section {
                    Text(viewStore.state.notice.articleId)
                    
                    Text("`notice.articleId`")
                } header: {
                    Text("고유번호")
                }

                Section {
                    Text(viewStore.state.notice.category)
                    
                    Text("`notice.category`")
                } header: {
                    Text("공지 카테고리")
                }
                
                Section {
                    Text(viewStore.state.notice.postedDate)
                    
                    Text("`notice.postedDate`")
                } header: {
                    Text("Posted date")
                }
                
                Section {
                    Text(viewStore.state.notice.subject)
                    
                    Text("`notice.subject`")
                } header: {
                    Text("공지 제목")
                }
                
                Section {
                    Text(viewStore.state.notice.url)
                    
                    Text("`notice.url`")
                } header: {
                    Text("URL")
                }
            }
            // TODO: Move to parent
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewStore.send(.bookmarkButtonTapped)
                    } label: {
                        Image(
                            systemName: viewStore.state.isBookmarked
                            ? "bookmark.fill"
                            : "bookmark"
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        NoticeDetailView(
            store: Store(
                initialState: NoticeDetailFeature.State(notice: Notice.random),
                reducer: { NoticeDetailFeature() }
            )
        )
        .navigationTitle("Notice Detail View")
    }
}
