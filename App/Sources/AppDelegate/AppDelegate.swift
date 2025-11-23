//
//  AppDelegate.swift
//  KuringApp
//
//  Created by Jung Hwan Park on 11/22/25.
//

import SwiftUI
import Firebase
import PushNotifications

/// 푸시 알림 처리를 담당하는 클래스. `AppDelegate` 역할.
/// ```swift
/// struct MyApp: App {
///     @UIApplicationDelegateAdaptor(AppDelegate.self)
///     var appDelegate
///     // ...
/// }
/// ```
class AppDelegate: NSObject {
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
    
    func configureFirebase() {
        var filePath: String
        #if DEBUG
        filePath = Bundle.main.path(forResource: "GoogleService-Info-Debug", ofType: "plist")!
        #else
        filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        #endif
        let options: FirebaseOptions? = FirebaseOptions.init(contentsOfFile: filePath)
        FirebaseApp.configure(options: options!)
        Messaging.messaging().delegate = self
    }
    
    /// 공지를 일주일 동안 확인하지 않을 경우 알림을 띄우도록 합니다
    public func requestOneWeekInactiveNotification() async {
        guard Self.isCustomNotificationEnabled else { return }
        
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
