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
import SubscriptionFeatures
import ComposableArchitecture

@Reducer
public struct NotificationHistoryFeature {
    @Dependency(\.notificationHistory) var notificationHistory
    
    @ObservableState
    public struct State: Equatable {
        public var notifications: [NotificationHistoryEntity] = []
        /// 트리 네비게이션 - ``SubscriptionAppFeature``
        @Presents public var changeSubscription: SubscriptionAppFeature.State?
        
        public init() { }
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case fetchNotifications
        case notificationsFetched([NotificationHistoryEntity])
        
        case markAsRead(String)
        case deleteNotification(String)
        
        /// 구독 변경 버튼을 탭한 경우
        case changeSubscriptionButtonTapped
        /// ``SubscriptionAppFeature`` 의 Presentation 액션
        case changeSubscription(PresentationAction<SubscriptionAppFeature.Action>)
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
                    
                    do {
                        let notifications = try notificationHistory.fetch(descriptor)
                        
                        await send(.notificationsFetched(notifications))
                    } catch {
                        print("[NotificationHistory] 알림 내역 조회 실패: \(error)")
                        await send(.notificationsFetched([]))
                    }
                }
            case let .notificationsFetched(notifications):
                state.notifications = notifications
                return .none
            case let .markAsRead(id):
                return .run { send in
                    let descriptor = FetchDescriptor<NotificationHistoryEntity>(
                        predicate: #Predicate { $0.id == id }
                    )
                    
                    do {
                        if let notification = try notificationHistory.fetch(descriptor).first {
                            notification.isRead = true
                            try notificationHistory.update(notification)
                        }
                        
                        await send(.fetchNotifications)
                    } catch {
                        print("[NotificationHistory] 읽음 처리 실패: \(error)")
                       await send(.fetchNotifications)
                    }
                }
            case let .deleteNotification(id):
                return .run { send in
                    try notificationHistory.delete(id)
                    await send(.fetchNotifications)
                }
            case .changeSubscription(.presented(.subscriptionView(.subscriptionResponse))):
                /// ``SubscriptionAppFeature`` 액션
                state.changeSubscription = nil
                return .none
            case .changeSubscriptionButtonTapped:
                state.changeSubscription = SubscriptionAppFeature.State()
                return .none
            case .binding, .changeSubscription:
                return .none
            }
        }
        .ifLet(\.$changeSubscription, action: \.changeSubscription) {
            SubscriptionAppFeature()
        }
    }

    public init() { }
}
