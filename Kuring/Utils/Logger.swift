//
//  Logger.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/02/22.
//

import Foundation
import FirebaseAnalytics

class Logger {
    static func debug(_ log: Any?) {
#if DEBUG
        print("[com.kuring.service] ✅ \(String(describing: log))")
#else
        Analytics.logEvent("com.kuring.service.logger.debug", parameters: ["log": log])
#endif
    }
}
