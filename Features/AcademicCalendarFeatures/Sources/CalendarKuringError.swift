//
//  CalendarKuringError.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/27/25.
//

import Foundation

public enum CalendarKuringError: Error, Equatable {
    case error(String)
    
    public static func == (lhs: CalendarKuringError, rhs: CalendarKuringError) -> Bool {
        switch (lhs, rhs) {
        case let (.error(lmsg), .error(rmsg)):
            return lmsg == rmsg
        }
    }
}
