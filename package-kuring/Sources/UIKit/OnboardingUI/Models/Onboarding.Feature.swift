//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

extension Onboarding {
    public struct Feature: Identifiable {
        public let image: Image
        public let title: String
        public var subtitle: String
        
        public var id: String { title + subtitle }
        
        public init(
            image: Image,
            title: String,
            subtitle: String
        ) {
            self.image = image
            self.title = title
            self.subtitle = subtitle
        }
    }
}
