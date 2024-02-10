//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

extension Onboarding {
    public struct Version: Hashable {
        public let major: Int
        public let minor: Int
        public let patch: Int
        
        public init(
            major: Int,
            minor: Int,
            patch: Int
        ) {
            self.major = major
            self.minor = minor
            self.patch = patch
        }
    }
}

// MARK: Comparable
extension Onboarding.Version: Comparable {
    public static func < (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        lhs.description.compare(rhs.description, options: .numeric) == .orderedAscending
    }
}

// MARK: CustomStringConvertible
extension Onboarding.Version: CustomStringConvertible {
    public var description: String {
        [major, minor, patch]
            .map(String.init)
            .joined(separator: ".")
    }
}

// MARK: ExpressibleByStringLiteral
extension Onboarding.Version: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        let components = value
            .components(separatedBy: ".")
            .compactMap(Int.init)
        major = components.indices.contains(0) ? components[0] : 0
        minor = components.indices.contains(1) ? components[1] : 0
        patch = components.indices.contains(2) ? components[2] : 0
    }
}

// MARK: Current
extension Onboarding.Version {
    public static func current(
        in bundle: Bundle = .main
    ) -> Onboarding.Version {
        let shortVersionString = bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        return .init(stringLiteral: shortVersionString ?? "")
    }
}
