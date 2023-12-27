import Models
import SwiftUI
import NoticeFeatures
import ComposableArchitecture

struct NoticeDetailView: View {
    @Bindable var store: StoreOf<NoticeDetailFeature>
    
    var body: some View {
        List {
            Section {
                Text(self.store.notice.articleId)
                
                Text("`notice.articleId`")
            } header: {
                Text("고유번호")
            }
            
            Section {
                Text(self.store.notice.category)
                
                Text("`notice.category`")
            } header: {
                Text("공지 카테고리")
            }
            
            Section {
                Text(self.store.notice.postedDate)
                
                Text("`notice.postedDate`")
            } header: {
                Text("Posted date")
            }
            
            Section {
                Text(self.store.notice.subject)
                
                Text("`notice.subject`")
            } header: {
                Text("공지 제목")
            }
            
            Section {
                Text(self.store.state.notice.url)
                
                Text("`notice.url`")
            } header: {
                Text("URL")
            }
        }
        // TODO: Move to parent
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.store.send(.bookmarkButtonTapped)
                } label: {
                    Image(
                        systemName: self.store.isBookmarked
                        ? "bookmark.fill"
                        : "bookmark"
                    )
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
