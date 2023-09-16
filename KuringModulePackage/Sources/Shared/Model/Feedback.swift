//
//  Feedback.swift
//
//
//  Created by Jaesung Lee on 2023/09/13.
//

import Foundation

public struct Feedback: Codable, Equatable {
    public var content: String
    
    public init(content: String) {
        self.content = content
    }
}

