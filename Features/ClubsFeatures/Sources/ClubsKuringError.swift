//
//  ClubsKuringError.swift
//  ClubsFeatures
//
//  Created by Jung Hwan Park on 3/1/26.
//

import Foundation

public enum ClubsKuringError: Error, Equatable {
    case error(String)
    
    public static func == (lhs: ClubsKuringError, rhs: ClubsKuringError) -> Bool {
        switch (lhs, rhs) {
        case let (.error(lmsg), .error(rmsg)):
            return lmsg == rmsg
        }
    }
}
