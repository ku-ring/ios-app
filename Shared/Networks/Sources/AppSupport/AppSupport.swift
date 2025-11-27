//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

struct AppSupport: Decodable, Equatable {
    let minimumVersion: String
    
    enum CodingKeys: String, CodingKey {
        case minimumVersion = "minimum_version"
    }
}
