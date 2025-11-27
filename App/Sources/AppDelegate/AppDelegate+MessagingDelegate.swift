//
//  AppDelegate+MessagingDelegate.swift
//  KuringApp
//
//  Created by Jung Hwan Park on 11/23/25.
//

import Firebase
import Dependencies

extension AppDelegate: MessagingDelegate {
    /// FCM 등록 토큰을 받았을 때 호출되는 이벤트
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        
        if self.fcmToken != fcmToken {
            self.fcmToken = fcmToken
            
            // 토큰 값이 다른 경우에만 해당 API 호출
            @Dependency(\.kuringLink) var kuringLink
            Task(priority: .background) {
                do {
                    _ = try await kuringLink.registerAuthorization()
                } catch {
                    print("유저 FCM 토큰 등록 실패: \(error)")
                }
            }
        }
    }
}
