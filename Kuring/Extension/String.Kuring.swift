//
//  String.Kuring.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import Foundation

struct UsernameProtocol {
    /// ```swift
    /// (?=.{8,20}$) // username is 5-15 characters long
    /// (?![_.]) // no _ or . at the beginning
    /// (?!.*[_.]{2}) // no __ or _. or ._ or .. inside
    /// [a-zA-Z가-힣0-9._] // allowed characters
    /// (?<![_.]) // no _ or . at the end
    /// ```
    static let regex: NSRegularExpression = try! NSRegularExpression(pattern: "^(?=.{2,15}$)(?![_.])(?!.*[_.]{2})[a-zA-Z가-힣0-9._]+(?<![_.])$")
}

extension String {
    var conformsToUsernameProtocol: Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        return UsernameProtocol.regex.firstMatch(in: self, options: [], range: range) != nil
    }
}

