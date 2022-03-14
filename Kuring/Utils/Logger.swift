//
//  Logger.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/02/22.
//

import Foundation
import FirebaseAnalytics
import AppsFlyerLib

class Logger {
    static func debug(_ log: Any?) {
        let time = Date().formatted(date: .complete, time: .complete)
#if DEBUG
        print("[com.kuring.service] [\(time)]\n✅ \(String(describing: log))")
#else
        let logString = String(describing: log)
        Analytics.logEvent(
            "com_kuring_service_logger_debug",
            parameters: [
                "version": Bundle.appVersion,
                "log": logString,
                "time": time
            ]
        )
        AppsFlyerLib.shared().logEvent(
            "com_kuring_service_logger_debug",
            withValues: [
                "version": Bundle.appVersion,
                "log": logString,
                "time": time
            ]
        )
#endif
    }
    
    static func error(_ log: String) {
        let time = Date().formatted(date: .complete, time: .complete)
#if DEBUG
        print("[com.kuring.service] [\(time)]\n🚨 \(log))")
#else
        Analytics.logEvent(
            "com_kuring_service_logger_error",
            parameters: [
                "version": Bundle.appVersion,
                "log": log,
                "time": time
            ]
        )
        AppsFlyerLib.shared().logEvent(
            "com_kuring_service_logger_debug",
            withValues: [
                "version": Bundle.appVersion,
                "log": logString,
                "time": time
            ]
        )
#endif
    }
}
