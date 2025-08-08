//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import Firebase

extension Notifications {
    /// - Note: `applicationDidFinishLaunching` 와의 차이점: The default Firebase app has not yet been configured. Add `FirebaseApp.configure()` to your application initialization. This can be done in in the App Delegate's application(_:didFinishLaunchingWithOptions:)` (or the `@main` struct's initializer in SwiftUI). Read more: https://goo.gl/ctyzm8.
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        configureFirebase()
        registerRemoteNotification(for: application)
        return true
    }
    
    
    /// 푸시알림 디바이스 토큰 등록되었을 때 호출되는 이벤트
    public func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// 푸시 알림을 위한 등록에 실패했을 때 호출되는 이벤트
    public func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        
    }
}
