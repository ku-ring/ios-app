//
//  AcademicEvent.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/25/25.
//

import Dependencies
import SwiftData
import Models

public struct AcademicScheduleDB {
    public var fetch: @Sendable (FetchDescriptor<AcademicScheduleEntity>) throws -> AcademicScheduleEntity?
    public var add: @Sendable (AcademicScheduleEntity) throws -> Void
    public var delete: @Sendable (AcademicScheduleEntity) throws -> Void
    public var update: @Sendable (AcademicScheduleEntity, [AcademicEventEntity]) throws -> Void
    
    public enum DBError: Error {
        case fetch
        case add
        case delete
        case update
    }
}

extension AcademicScheduleDB: DependencyKey {
    public static let liveValue = Self(
        fetch: { descriptor in
            do {
                @Dependency(\.swiftData.context) var modelContext
                let context = try modelContext()
                return try context.fetch(descriptor).first
            } catch {
                throw DBError.fetch
            }
        },
        add: { schedule in
            do {
                @Dependency(\.swiftData.context) var modelContext
                let context = try modelContext()
                context.insert(schedule)
                try context.save()
            } catch {
                throw DBError.add
            }
        },
        delete: { schedule in
            do {
                @Dependency(\.swiftData.context) var modelContext
                let context = try modelContext()
                context.delete(schedule)
                try context.save()
            } catch {
                throw DBError.delete
            }
        },
        update: { schedule, newEvents in
            do {
                @Dependency(\.swiftData.context) var modelContext
                let context = try modelContext()
                
                schedule.events = newEvents
                schedule.lastUpdated = .now
                
                try context.save()
            } catch {
                throw DBError.update
            }
        }
    )
}

extension AcademicScheduleDB: TestDependencyKey {
    public static let testValue = Self(
        fetch: unimplemented("\(Self.self).fetch"),
        add: unimplemented("\(Self.self).add"),
        delete: unimplemented("\(Self.self).delete"),
        update: unimplemented("\(Self.self).update")
    )
    
    public static let noop = Self(
        fetch: { _ in nil },
        add: { _ in },
        delete: { _ in },
        update: { _, _ in }
    )
}

extension DependencyValues {
    public var academicSchedules: AcademicScheduleDB {
        get { self[AcademicScheduleDB.self] }
        set { self[AcademicScheduleDB.self] = newValue }
    }
}
