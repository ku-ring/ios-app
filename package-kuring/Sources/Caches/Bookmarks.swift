//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import Foundation
import Dependencies

public struct Bookmarks {
    public var add: (_ notice: Notice) throws -> Void
    public var remove: (_ id: Notice.ID) throws -> Void
    public var getAll: () throws -> [Notice]
    public init(
        add: @escaping (_ notice: Notice) throws -> Void,
        remove: @escaping (_ noidtice: Notice.ID) throws -> Void,
        getAll: @escaping () throws -> [Notice]
    ) {
        self.add = add
        self.remove = remove
        self.getAll = getAll
    }

    /// 객체를 함수 호출처럼 사용하여 모든 북마크를 가져올 수 있습니다.
    /// ```swift
    /// let cachedNotices = try bookmarks()
    /// ```
    public func callAsFunction() throws -> [Notice] {
        try getAll()
    }
}

extension Bookmarks {
    public static let `default` = Bookmarks(
        add: { notice in
            let folderURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            .appendingPathComponent("bookmarks")

            try FileManager.default.createDirectory(
                at: folderURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
            let fileURL = folderURL.appendingPathComponent("\(notice.id).json")

            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            try encoder.encode(notice).write(to: fileURL)
            
            @Dependency(\.spotlight) var spotlight
            try spotlight.add(notice)
        },
        remove: { noticeID in
            let fileURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            .deletingPathExtension()
            .appendingPathComponent("bookmarks")
            .appendingPathComponent("\(noticeID).json")

            if FileManager.default.fileExists(atPath: fileURL.path()) {
                try FileManager.default.removeItem(atPath: fileURL.path())
            }
        },
        getAll: {
            let fileURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            .appendingPathComponent("bookmarks")

            let contents = try FileManager.default
                .contentsOfDirectory(
                    at: fileURL,
                    includingPropertiesForKeys: nil
                )
            let datas = contents.compactMap { try? Data(contentsOf: $0) }
            let notices = datas.compactMap {
                try? JSONDecoder().decode(Notice.self, from: $0)
            }
            return notices
        }
    )
}

extension Bookmarks: DependencyKey {
    public static var liveValue: Bookmarks = .default
}

extension DependencyValues {
    public var bookmarks: Bookmarks {
        get { self[Bookmarks.self] }
        set { self[Bookmarks.self] = newValue }
    }
}
