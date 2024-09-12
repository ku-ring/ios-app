//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ColorSet
import CommonUI
import EKEventUI
import ActivityUI
import NoticeFeatures
import ComposableArchitecture
import EventKit

public struct NoticeDetailView: View {
    @Bindable var store: StoreOf<NoticeDetailFeature>
    
    var noticeProvider: NoticeProvider? {
        NoticeProvider.univNoticeTypes.first { $0.name == store.notice.category }
        ?? NoticeProvider.departments.first { $0.name == store.notice.category }
    }
    
    public var body: some View {
        WebView(urlString: store.notice.url)
            .background(Color.Kuring.bg)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $store.isPresentedEventView) {
//                guard let eventStore = ,
//                      let event = store.state.event else {
//                    EmptyView()
//                }
                EKEventView(
                    eventStore: store.state.eventStore!,
                    event: store.state.event!
                )
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(noticeProvider?.korName ?? "")
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        self.store.send(.calenarButtonTapped)
                    } label: {
                        Image(systemName: "calendar.badge.plus")
                    }
                    Button {
                        self.store.send(.bookmarkButtonTapped)
                    } label: {
                        Image(
                            self.store.isBookmarked
                            ? "bookmark-fill"
                            : "bookmark",
                            bundle: Bundle.notices
                        )
                    }
                    
                    ShareLink(
                        item: store.notice.url
                    ) {
                        Image("share", bundle: Bundle.notices)
                    }
                }
            }
    }
    
    public init(store: StoreOf<NoticeDetailFeature>) {
        self.store = store
    }
    
    func make(eventStore: EKEventStore) -> EKEvent {
        let event = EKEvent(eventStore: eventStore)
        event.title = "당근"
        let structuredLocation = EKStructuredLocation(title: "Starbucks")
        structuredLocation.geoLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        event.structuredLocation = structuredLocation
        event.url = URL(string: "www.naver.com")
        event.isAllDay = true
        let alarm = EKAlarm(relativeOffset: -86400)
        event.notes = "자동작성된 이벤트"
        event.alarms = [alarm]
        return event
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
    }
}
//let eventStore = EKEventStore()
//let event = make(eventStore: eventStore)
//EKEventView(
//    eventStore: eventStore,
//    event: event
//)
