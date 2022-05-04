//
//  AppDelegate.RemoteNotification.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/02/14.
//

import UIKit
import KuringSDK
import KuringCommons
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
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.error("Failed to register for remote notification with error: \(error.localizedDescription)")
    }
}

// MARK: - FirebaseMessaging
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            Logger.error("No FCM token")
            return
        }

        Kuring.register(fcmToken: fcmToken)
        Logger.debug("FCM token: \(fcmToken)")
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
        Logger.debug("포어그라운드에서 알림을 받았습니다: \(userInfo)")
        
        // MARK: Kuring
        Kuring.userNotificationCenter(
            center,
            willPresent: notification
        )
        
        completionHandler([.banner, .list, .badge, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // MARK: Analytics
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        Logger.debug("푸시 알림을 받았습니다: \(userInfo)")

        openBanner(with: userInfo)
        
        completionHandler()
    }
    
    /// 배너를 눌렀을 때, 웹뷰를 보여줍니다.
    func openBanner(with userInfo: [AnyHashable: Any]) {
        guard let articleID = userInfo["articleId"] as? String else { return }
        guard let categoryString = userInfo["category"] as? String else { return }
        guard let navigationController = self.window?.rootViewController as? UINavigationController else { return }
        
        let articleURL = NoticeType.from(categoryString) == .도서관
        ? Notice.NoticeURL.library(articleID).urlString
        : Notice.NoticeURL.original(articleID).urlString
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let noticeWebVC = storyboard.instantiateViewController(
            withIdentifier: "NoticeWebViewController"
        ) as? NoticeWebViewController else { return }
        noticeWebVC.articleURL = articleURL
        noticeWebVC.articleID = "\(articleID)"
        navigationController.pushViewController(noticeWebVC, animated: true)
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
        Logger.debug("대기중인 푸시 알림이 실행되었습니다: \(userInfo)")
        
        // MARK: Kuring
        Kuring.application(
            application,
            didReceiveRemoteNotification: userInfo
        )
        
        completionHandler(.newData)
    }
}

// MARK: - KuringDelegate
extension AppDelegate: KuringDelegate {
    func didReceiveNotification(_ notification: KuringSDK.Notification) {
        Logger.debug("Received \(notification.subject)")
    }

    func didReadyToCreateNotificationBanner(title: String, body: String, identifier: String) {
        Logger.debug("did ready to create notification banner - \(title) - \(body) - \(identifier)")
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = nil
        
        let identifier = identifier
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                Logger.error("Failed to show banner: \(error.localizedDescription)")
            }
        }
    }
    
    func didUpdateSubscription(_ subscription: Subscription) {
        Logger.debug("\(subscription.categories)")
    }
}
