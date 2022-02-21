//
//  Logger.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/02/22.
//

import Foundation

class Logger {
    static func debug(_ log: Any?) {
    #if DEBUG
        print("✅ \(String(describing: log))")
    #endif
    }
}
