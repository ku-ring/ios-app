//
//  LoginKuringError.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/17/25.
//

import Foundation

public enum LoginKuringError: Error, Equatable {
    case error(String)
    
    public static func == (lhs: LoginKuringError, rhs: LoginKuringError) -> Bool {
        switch (lhs, rhs) {
        case let (.error(lmsg), .error(rmsg)):
            return lmsg == rmsg
        }
    }
}
