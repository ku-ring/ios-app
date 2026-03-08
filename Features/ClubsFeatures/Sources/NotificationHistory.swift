//
//  NotificationHistory.swift
//  ClubsFeatures
//
//  Created by Jung Hwan Park on 3/5/26.
//

import Models
import Networks
import SwiftData
import Foundation
import Dependencies
import ComposableArchitecture

@Reducer
public struct NotificationHistoryFeature {
    @Dependency(\.notificationHistory) var notificationHistory
    
    @ObservableState
    public struct State: Equatable {
        public var notifications: [NotificationHistoryEntity] = []
        
        public init() { }
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case fetchNotifications
        case notificationsFetched([NotificationHistoryEntity])
        
        case markAsRead(String)
        case deleteNotification(String)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .fetchNotifications:
                return .run { send in
                    let descriptor = FetchDescriptor<NotificationHistoryEntity>(
                        sortBy: [SortDescriptor(\.receivedAt, order: .reverse)]
                    )
                    
                    let notifications = try notificationHistory.fetch(descriptor)
                    
                    await send(.notificationsFetched(notifications))
                }
            case let .notificationsFetched(notifications):
                state.notifications = notifications
                return .none
            case let .markAsRead(id):
                return .run { send in
                    let descriptor = FetchDescriptor<NotificationHistoryEntity>(
                        predicate: #Predicate { $0.id == id }
                    )
                    
                    if let notification = try notificationHistory.fetch(descriptor).first {
                        notification.isRead = true
                        try notificationHistory.update(notification)
                    }
                    
                    await send(.fetchNotifications)
                }
            case let .deleteNotification(id):
                return .run { send in
                    try notificationHistory.delete(id)
                    await send(.fetchNotifications)
                }
            case .binding:
                return .none
            }
        }
    }

    public init() { }
}
