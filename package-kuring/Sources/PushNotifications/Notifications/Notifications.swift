//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import Models
import SwiftUI
import UserNotifications

/// 푸시 알림 처리를 담당하는 클래스. `AppDelegate` 역할.
/// ```swift
/// struct MyApp: App {
///     @UIApplicationDelegateAdaptor(Notifications.self) 
///     var appDelegate
///     // ...
/// }
/// ```
public class Notifications: NSObject, UIApplicationDelegate {
    @AppStorage("com.kuring.sdk.notification.custom")
    static var isCustomNotificationEnabled: Bool = true
    
    @AppStorage("com.kuring.sdk.v2.token.fcm")
    var fcmToken: String = ""
    
    func onTapRemoteNotification(with userInfo: [String: Any]) throws {
        let message = try Message(userInfo: userInfo)
        Task { @MainActor in
            // 종료된 앱을 시작시키는 경우를 고려하여 2초 딜레이.
            try await Task.sleep(for: .seconds(1.5))
            newMessagePublisher.send(message)
        }
    }
}

// MARK: - 공지를 일주일 동안 확인하지 않을 경우
extension Notifications {
    /// 공지를 일주일 동안 확인하지 않을 경우 알림을 띄우도록 합니다
    public func requestOneWeekInactiveNotification() async {
        guard Notifications.isCustomNotificationEnabled else { return }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents.notificationDate, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "공지를 일주일 동안 확인하지 않았어요!"
        content.body = "놓친 공지가 있는지 확인해보세요 🔔"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            // TODO: 에러 처리
            return
        }
    }
}
