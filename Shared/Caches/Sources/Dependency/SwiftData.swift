//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation
import SwiftData
import Dependencies
import Models

fileprivate let appContext: ModelContext = {
    do {
        let url = URL.applicationSupportDirectory.appending(path: "Model.sqlite")
        let config = ModelConfiguration(url: url)
        
        let container = try ModelContainer(
            for: ChatInfo.self,
            AcademicEventEntity.self,
            AcademicScheduleEntity.self,
            NotificationHistoryEntity.self,
            configurations: config
        )
        return ModelContext(container)
    } catch {
        fatalError("Failed to create container.")
    }
}()

public struct DataBase {
    public var context: () throws -> ModelContext
}

extension DataBase: DependencyKey {
    public static let liveValue = Self(
        context: { appContext }
    )
}

extension DataBase: TestDependencyKey {
    public static var previewValue = Self.noop
    
    public static let testValue = Self(
        context: unimplemented("\(Self.self).context")
    )
    
    public static let noop = Self(
        context: unimplemented("\(Self.self).context")
    )
}

extension DependencyValues {
    public var swiftData: DataBase {
        get { self[DataBase.self] }
        set { self[DataBase.self] = newValue }
    }
}
