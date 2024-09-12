//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import SwiftUI
import EventKit
import ActivityUI
import ComposableArchitecture

@Reducer
public struct NoticeDetailFeature {
    @ObservableState
    public struct State: Equatable {
        public var notice: Notice
        public var isBookmarked: Bool = false
        public var isPresentedEventView: Bool = false
        public var eventStore: EKEventStore?
        public var event: EKEvent?

        public init(notice: Notice, isBookmarked: Bool? = nil) {
            @Dependency(\.bookmarks) var bookmarks
            self.notice = notice
            if let isBookmarked {
                self.isBookmarked = isBookmarked
                return
            }
            do {
                self.isBookmarked = try bookmarks().contains { $0.id == notice.id }
            } catch {
                self.isBookmarked = false
            }
        }
    }

    public enum Action: BindableAction, Equatable {
        case bookmarkButtonTapped
        case calenarButtonTapped
        
        case binding(BindingAction<State>)

        case delegate(Delegate)

        public enum Delegate: Equatable {
            case bookmarkUpdated(_ notice: Notice, _ isBookmarkd: Bool)
        }
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .bookmarkButtonTapped:
                state.isBookmarked.toggle()
                return .none
                
            case .calenarButtonTapped:
                let eventStore = EKEventStore()
                let event = EKEvent(eventStore: eventStore)
                event.title = state.notice.subject
                let structuredLocation = EKStructuredLocation(title: "건국대학교 05029 대한민국 서울특별시 광진구 능동로 120")
                structuredLocation.geoLocation = CLLocation(latitude: 37.54360, longitude: 127.07747)
                event.url = URL(string: state.notice.url)
                event.isAllDay = true
                let alarm = EKAlarm(relativeOffset: -86400)
                event.notes = "쿠링에서 \(Date.now)에 등록된 일정입니다."
                event.alarms = [alarm]
                
                state.eventStore = eventStore
                state.event = event
                state.isPresentedEventView.toggle()
                
                return .none
                
            case .delegate:
                return .none
            }
        }
        .onChange(of: \.isBookmarked) { _, newValue in
            Reduce { state, _ in
                return .send(.delegate(.bookmarkUpdated(state.notice, newValue)))
            }
        }
    }
    
    public init() { }
}
