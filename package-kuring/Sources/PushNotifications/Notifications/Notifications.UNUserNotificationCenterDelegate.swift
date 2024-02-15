//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import Firebase
import UserNotifications

extension Notifications: UNUserNotificationCenterDelegate {
    func registerRemoteNotification(for application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: { isSucceed, error in }
        )
        application.registerForRemoteNotifications()
    }
    
    /// 포어그라운드에서 푸시 알림을 받은 경우
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        /// you only need to call this if you set the `FirebaseAppDelegateProxyEnabled` flag to `NO` in your `Info.plist`. If `FirebaseAppDelegateProxyEnabled` is either missing or set to `YES` in your `Info.plist`, the library will call this automatically.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // TODO: 로컬 알림을 띄워줘야 하는가?
        
        guard let userInfo = userInfo as? [String: Any] else { return [] }
        do {
            let _ = try Message(userInfo: userInfo)
            return [.banner, .sound]
        } catch {
            // 커스텀 알림 수신 미동의 인데 커스텀 알림이 온 경우
            return []
        }
    }
    
    /// 푸시 알림을 탭 했을 때
    /// - Important: ``newMessagePublisher`` 를 구독하여 ``Message`` 객체를 이벤트로 전달받을 수 있습니다.
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        guard let userInfo = userInfo as? [String: Any] else { return }
        do {
            try onTapRemoteNotification(with: userInfo)
        } catch {
            return
        }
    }
    
    /// 앱이 백그라운드 상태일 때 푸시 알림을 탭한 경우
    /// 만약 앱이 백그라운드 상태인 동안 푸시 알림을 받는다면, 알림을 탭하여 앱을 실행할 때까지 호출되지 않는 이벤트
    /// - Important: ``newMessagePublisher`` 를 구독하여 ``Message`` 객체를 이벤트로 전달받을 수 있습니다.
    public func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any]
    ) async -> UIBackgroundFetchResult {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Kuring.application(application, didReceiveRemoteNotification: userInfo)
        guard let userInfo = userInfo as? [String: Any] else { return .failed }
        do {
            try onTapRemoteNotification(with: userInfo)
            return .newData
        } catch {
            return .failed
        }
    }
}
