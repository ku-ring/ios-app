//
//  NotificationHistoryView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/18/26.
//

import Models
import SwiftUI
import ColorSet
import ClubsFeatures
import SubscriptionUI
import ComposableArchitecture

public struct NotificationHistoryView: View {
    @Bindable var store: StoreOf<NotificationHistoryFeature>
    
    public init(store: StoreOf<NotificationHistoryFeature>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            ForEach(store.notifications) { notification in
                NotificationHistoryRow(notification: notification)
                    .listRowInsets(.init())
                    .listRowSeparator(.visible)
                    .alignmentGuide(.listRowSeparatorLeading) { _ in
                        return 0
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            store.send(.deleteNotification(notification.id))
                        } label: {
                            Text("삭제")
                        }
                    }
            }
        }
        .listStyle(.plain)
        .background(Color.Kuring.bg)
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(.changeSubscriptionButtonTapped)
                } label: {
                    Image("settings", bundle: .module)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 26, height: 26)
                        .foregroundStyle(Color.Kuring.gray600)
                }
            }
        }
        .task {
            store.send(.fetchNotifications)
        }
        .sheet(
            item: $store.scope(
                state: \.changeSubscription,
                action: \.changeSubscription
            )
        ) { store in
            SubscriptionApp(store: store)
        }
    }
}
