//
//  PushNotificationRouter.swift
//  KuringApp
//
//  Created by Jung Hwan Park on 1/20/26.
//

import Models
import SwiftUI
import Combine
import PushNotifications

@MainActor
class PushRouter: ObservableObject {
    static let shared = PushRouter()
    
    @Published var activeNotice: Notice?
    /// 앱이 준비되기 전, 공지사항을 임시로 들고있다가 준비됐을때 공지사항을 보여주기 위함
    private var pendingNotice: Notice?
    private var isAppReady = false

    /// 푸시알림 라우터가 준비 되었을때 사용한다
    func setReady() {
        isAppReady = true
        if let pending = pendingNotice {
            activeNotice = pending
            pendingNotice = nil
        }
    }

    /// 푸시 알림 액션
    func handle(_ message: Message) {
        switch message {
        case .notice(let notice):
            if isAppReady {
                activeNotice = notice
            } else {
                pendingNotice = notice
            }
        case .custom(_, _, let link):
            if let link, let url = URL(string: link) {
                UIApplication.shared.open(url)
            }
        default: break
        }
    }
}
