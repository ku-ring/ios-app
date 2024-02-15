//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import Firebase

extension Notifications {
    public func applicationDidFinishLaunching(_ application: UIApplication) {
        // TODO: `didFinishLaunchingWithOptions` 와 차이점?
        configureFirebase()
        registerRemoteNotification(for: application)
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
