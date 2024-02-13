//
//  Spotlight.swift
//
//
//  Created by Geon Woo lee on 2/13/24.
//

import Models
import CoreSpotlight
import ComposableArchitecture

public struct Spotlight: DependencyKey {
    public var add: (_ notice: Notice) throws -> Void
    
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
