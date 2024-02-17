//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import Models
import Dependencies
import CoreSpotlight

public struct Spotlight: DependencyKey {
    public var add: (_ notice: Notice) -> Void
    
    public init(
        add: @escaping (_: Notice) -> Void
    ) {
        self.add = add
    }
}

extension Spotlight {
    public static let `default` = Spotlight(
        add: { notice in
            let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
            attributeSet.displayName = notice.subject
            attributeSet.thumbnailData = UIImage(systemName: "AppIcon")?.pngData()
            
            let searchableItem = CSSearchableItem(uniqueIdentifier: notice.id,
                                                  domainIdentifier: "com.kuring.service.bookmarks",
                                                  attributeSet: attributeSet)
            
            CSSearchableIndex.default().indexSearchableItems([searchableItem]) { _ in }
        }
    )
}

extension Spotlight {
    public static let liveValue: Spotlight = .default
}

extension DependencyValues {
    public var spotlight: Spotlight {
        get { self[Spotlight.self] }
        set { self[Spotlight.self] = newValue }
    }
}
