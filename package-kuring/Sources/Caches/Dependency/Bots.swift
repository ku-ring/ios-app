//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftData
import Dependencies
import Models
import SwiftUI
import Foundation

public struct BotDataBase {
    public var fetch: @Sendable (FetchDescriptor<ChatInfo>) throws -> [ChatInfo]
    public var add: @Sendable (ChatInfo) throws -> Void
    public var update: @Sendable (ChatInfo) throws -> Void
    
    public enum BotError: Error {
        case add
        case update
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
            @Dependency(\.swiftData.context) var modelContext
            let botContext = try modelContext()
            botContext.insert(model)
            try botContext.save()
        },
        update: { model in
            @Dependency(\.swiftData.context) var modelContext
            let botContext = try modelContext()
            let modelID = model.index
            /// index 일치 확인
            if let existing = try botContext.fetch(FetchDescriptor<ChatInfo>(predicate: #Predicate<ChatInfo> { $0.index == modelID })).first {
                existing.text = model.text
                try botContext.save()
            } else {
                throw BotError.update
            }
        }
    )
}

extension BotDataBase: TestDependencyKey {
    public static var previewValue = Self.noop
    
    public static let testValue = Self(
        fetch: unimplemented("\(Self.self).fetchDescriptor"),
        add: unimplemented("\(Self.self).add"),
        update: unimplemented("\(Self.self).update")
    )
    
    public static let noop = Self(
        fetch: { _ in [] },
        add: { _ in },
        update: { _ in }
    )
}

extension DependencyValues {
    public var bots: BotDataBase {
        get { self[BotDataBase.self] }
        set { self[BotDataBase.self] = newValue }
    }
}
