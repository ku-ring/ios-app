//
//  KuringLink.swift
//
//
//  Created by Jaesung Lee on 2023/09/13.
//

import KuringLink
import ComposableArchitecture

extension KuringLink: DependencyKey {
    public static let liveValue = KuringLink.liveValue
}

extension DependencyValues {
    public var kuringLink: KuringLink {
        get { self[KuringLink.self] }
        set { self[KuringLink.self] = newValue }
    }
}
