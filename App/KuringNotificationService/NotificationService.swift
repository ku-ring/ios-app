//
//  NotificationService.swift
//  KuringNotificationService
//
//  Created by Jung Hwan Park on 3/16/26.
//

import Caches
import Models
import Dependencies
import PushNotifications
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent else {
            contentHandler(request.content)
            return
        }
        
        defer { contentHandler(bestAttemptContent) }
        
        let userInfo = bestAttemptContent.userInfo
        if let type = (userInfo["messageType"] ?? userInfo["type"]) as? String,
           let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let title = alert["title"] as? String,
           let body = alert["body"] as? String
        {
            @Dependency(\.notificationHistory) var notificationHistoryDB
            do {
                try notificationHistoryDB.add(NotificationHistoryEntity(title: title, body: body, type: type))
            } catch {
                print("NotifcationService Error:: \(error.localizedDescription)")
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
