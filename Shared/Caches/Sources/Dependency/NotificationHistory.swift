//
//  NotificationHistory.swift
//  Caches
//
//  Created by Jung Hwan Park on 3/5/26.
//

import Models
import SwiftData
import Foundation
import Dependencies

public struct NotificationHistoryDB {
    public var fetch: @Sendable (FetchDescriptor<NotificationHistoryEntity>) throws -> [NotificationHistoryEntity]
    public var add: @Sendable (NotificationHistoryEntity) throws -> Void
    public var delete: @Sendable (String) throws -> Void
    public var update: @Sendable (NotificationHistoryEntity) throws -> Void
    public var markAsRead: @Sendable (String) throws -> Void
    
    public enum DBError: Error {
        case fetch
        case add
        case delete
        case update
    }
}

extension NotificationHistoryDB: DependencyKey {
    public static let liveValue = Self(
        fetch: { descriptor in
            do {
                @Dependency(\.swiftData.context) var modelContext
                let context = try modelContext()
                return try context.fetch(descriptor)
            } catch {
                throw DBError.fetch
            }
        },
        add: { notification in
            do {
                @Dependency(\.swiftData.context) var modelContext
                let context = try modelContext()
                context.insert(notification)
                try context.save()
            } catch {
                throw DBError.add
            }
        },
        delete: { id in
            do {
                @Dependency(\.swiftData.context) var modelContext
                let context = try modelContext()
                
                let descriptor = FetchDescriptor<NotificationHistoryEntity>(
                    predicate: #Predicate { $0.id == id }
                )
                
                if let entity = try context.fetch(descriptor).first {
                    context.delete(entity)
                    try context.save()
                }
                
            } catch {
                throw DBError.delete
            }
        },
        update: { notification in
            do {
                @Dependency(\.swiftData.context) var modelContext
                let context = try modelContext()
                try context.save()
            } catch {
                throw DBError.update
            }
        },
        markAsRead: { id in
            do {
                @Dependency(\.swiftData.context) var modelContext
                let context = try modelContext()
                
                let descriptor = FetchDescriptor<NotificationHistoryEntity>(
                    predicate: #Predicate { $0.id == id }
                )
                
                if let notification = try context.fetch(descriptor).first {
                    notification.isRead = true
                    try context.save()
                }
            } catch {
                throw DBError.update
            }
        }
    )
}

extension NotificationHistoryDB: TestDependencyKey {
    public static let testValue = Self(
        fetch: unimplemented("\(Self.self).fetch"),
        add: unimplemented("\(Self.self).add"),
        delete: unimplemented("\(Self.self).delete"),
        update: unimplemented("\(Self.self).update"),
        markAsRead: unimplemented("\(Self.self).markAsRead")
    )
    
    public static let noop = Self(
        fetch: { _ in [] },
        add: { _ in },
        delete: { _ in },
        update: { _ in },
        markAsRead: { _ in }
    )
}

extension DependencyValues {
    public var notificationHistory: NotificationHistoryDB {
        get { self[NotificationHistoryDB.self] }
        set { self[NotificationHistoryDB.self] = newValue }
    }
}

