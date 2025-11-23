//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftData
import Dependencies
import Models
import SwiftUI

public struct BotDataBase {
    public var fetch: @Sendable (FetchDescriptor<ChatInfo>) throws -> [ChatInfo]
    public var add: @Sendable (ChatInfo) throws -> Void
    public var delete: @Sendable (ChatInfo) throws -> Void
    
    public enum BotError: Error {
        case add
        case delete
    }
}

extension BotDataBase: DependencyKey {
    public static let liveValue = Self(
        fetch: { descriptor in
            @Dependency(\.swiftData.context) var modelContext
            let botContext = try modelContext()
            return try botContext.fetch(descriptor)
        },
        add: { model in
            do {
                @Dependency(\.swiftData.context) var modelContext
                let botContext = try modelContext()
                botContext.insert(model)
                try botContext.save()
            } catch {
                throw BotError.add
            }
        },
        delete: { model in
            do {
                @Dependency(\.swiftData.context) var modelContext
                let botContext = try modelContext()
                
                let modelToBeDelete = model
                botContext.delete(modelToBeDelete)
            } catch {
                throw BotError.delete
            }
        }
    )
}

extension BotDataBase: TestDependencyKey {
    public static var previewValue = Self.noop
    
    public static let testValue = Self(
        fetch: unimplemented("\(Self.self).fetchDescriptor"),
        add: unimplemented("\(Self.self).add"),
        delete: unimplemented("\(Self.self).delete")
    )
    
    public static let noop = Self(
        fetch: { _ in [] },
        add: { _ in },
        delete: { _ in }
    )
}

extension DependencyValues {
    public var bots: BotDataBase {
        get { self[BotDataBase.self] }
        set { self[BotDataBase.self] = newValue }
    }
}
