//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

public struct Feedback: Codable, Equatable {
    public var content: String

    public init(content: String) {
        self.content = content
    }
}
