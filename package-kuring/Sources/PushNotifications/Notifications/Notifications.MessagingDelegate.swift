//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Firebase

extension Notifications: MessagingDelegate {
    func configureFirebase() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    /// FCM 등록 토큰을 받았을 때 호출되는 이벤트
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        self.fcmToken = fcmToken
    }
}
