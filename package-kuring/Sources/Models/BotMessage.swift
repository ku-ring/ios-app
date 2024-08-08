//
//  File.swift
//  
//
//  Created by 최효원 on 8/8/24.
//

import Foundation

public struct BotMessage: Codable, Equatable {
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
}
