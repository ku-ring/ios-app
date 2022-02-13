//
//  AppDelegate.RemoteNotification.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/02/14.
//

import UIKit
import KuringSDK
import FirebaseMessaging

extension AppDelegate {
    func registerForRemoteNotification(of application: UIApplication) {
        // MARK: FirebaseMessaging
        Messaging.messaging().delegate = self
        
        // MARK: UNUserNotificationCenter
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current()
            .requestAuthorization(options: authOptions) { _, _ in }
        application.registerForRemoteNotifications()
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: - FirebaseMessaging
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            print("[com.kuring.service] No FCM token")
            return
        }

        Kuring.register(fcmToken: fcmToken) { _ in }
        print("[com.kuring.service] FCM token: \(fcmToken)")
    }
}

// MARK: - UNUserNotificationCenter
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // MARK: Analytics
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // MARK: Kuring
        Kuring.userNotificationCenter(
            center,
            willPresent: notification,
            withCompletionHandler: completionHandler
        )
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // MARK: Analytics
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // MARK: Kuring
        Kuring.userNotificationCenter(
            center,
            didReceive: response,
            withCompletionHandler: completionHandler
        )
    }
}

// MARK: - UIApplicationDelegate
extension AppDelegate {
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // 만약 앱이 백그라운드 상태인 동안 메세지를 받는다면,
        // 이 콜백은 알림을 탭하여 앱을 실행할 때까지 절대로 호출 되지 않습니다
        
        // MARK: Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // MARK: Kuring
        Kuring.application(
            application,
            didReceiveRemoteNotification: userInfo,
            fetchCompletionHandler: completionHandler
        )
    }
}

// MARK: - KuringDelegate
extension AppDelegate: KuringDelegate {
    func didReceiveNotification(_ notification: KuringSDK.Notification) {
        createNotificationBanner(from: notification)
    }
    
    func didUpdateSubscription(_ subscription: Subscription) {
        
    }
    
    /**
     알림이 오면 배너를 생성하여 띄운다
     */
    func createNotificationBanner(from notification: KuringSDK.Notification) {
        let content = UNMutableNotificationContent()
        content.title = "🔔 쿠링! 새 공지가 왔어요!"
        content.body = notification.subject
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let identifier = notification.articleID
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("[com.kuring.service] Failed to show notification: \(error.localizedDescription)")
            }
        }
    }
}
