//
//  NoticeListFeature.swift
//
//
//  Created by Jaesung Lee on 2023/09/13.
//

import Model
import Foundation
import KuringDependencies
import ComposableArchitecture

public struct NoticeListFeature: Reducer {
    public struct State: Equatable {
        public var notices: IdentifiedArrayOf<Notice> = []
        public var hasMore: Bool = true
        
        public init(notices: IdentifiedArrayOf<Notice> = [], hasMore: Bool = true) {
            self.notices = notices
            self.hasMore = hasMore
        }
    }
    
    public enum Action {
        case onAppear
        case bookmarkButtonTapped(atOffset: Int)
        case noticesResponse([Notice])
        
        case noticeRow(NoticeRowFeature.Action)
    }
    
    @Dependency(\.kuringLink) var kuringLink
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let notices = try await kuringLink.fetchNotices(20, "bch", nil, 0)
                    await send(.noticesResponse(notices))
                }
            case let .bookmarkButtonTapped(atOffset: index):
                print(index)
                return .none
                
            case .noticesResponse(let notices):
                state.notices.append(contentsOf: notices)
                return .none
                
            case .noticeRow:
                return .none
            }
        }
//        .forEach(\.notices, action: /Action.noticeRow) {
//            NoticeRowFeature()
//        }
    }
}
