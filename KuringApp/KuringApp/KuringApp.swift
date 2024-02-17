//
//  KuringAppApp.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/13.
//

import Models
import SwiftUI
import CommonUI
import NoticeUI
import NoticeFeatures
import PushNotifications
import ComposableArchitecture

@main
struct KuringApp: App {
    @State private var newNotice: Notice?
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(Notifications.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // MARK: 앱 업데이트 알림
                .versionUpdateAlert()
                // MARK: 새 공지 보여주기 (알림 탭했을 때)
                .fullScreenCover(item: $newNotice) { notice in
                    NavigationStack {
                        NoticeDetailView(
                            store: Store(
                                initialState: NoticeDetailFeature.State(
                                    notice: notice,
                                    isBookmarked: false
                                ),
                                reducer: { NoticeDetailFeature() }
                            )
                        )
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    self.newNotice = nil
                                } label: {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                    }
                }
                // MARK: 푸시 알림을 탭 했을 때 호출
                .onReceive(newMessagePublisher) { message in
                    switch message {
                    // 새 공지
                    case let .notice(notice):
                        self.newNotice = notice
                    
                    // 커스텀 알림
                    case let .custom(title, body, link):
                        guard let link else { return }
                        guard let url = URL(string: link) else { return }
                        guard UIApplication.shared.canOpenURL(url) else { return }
                        UIApplication.shared.open(url)
                    }
                }
                // MARK: - 일주일 동안 공지를 확인하지 않았어요
                .onChange(of: scenePhase) { _, scenePhase in
                    guard scenePhase == .active else { return }
                    Task {
                        await appDelegate.requestOneWeekInactiveNotification()
                    }
                }
            
                // MARK: - 테스트: 새 공지
//                #if DEBUG
//                .onAppear {
//                    Task { @MainActor in
//                        try await Task.sleep(for: .seconds(1.5))
//                        let notice = Notice.random
//                        newMessagePublisher.send(.notice(notice))
//                        try await Task.sleep(for: .seconds(1.5))
//                        newMessagePublisher.send(
//                            .custom(
//                                title: "[건대교지] 건빵레터 #47",
//                                body: "#47 [당근알바] 광화문 한복판에서 5미터 ‘천공’ 굴리기",
//                                url: "https://stibee.com/api/v1.0/emails/share/1oXWNovPHiqH-CiArIVZn8tOQmkmHVU"
//                            )
//                        )
//                    }
//                }
//                #endif
        }
    }
}
