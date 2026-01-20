//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import CommonUI
import NoticeUI
import SwiftData
import OnboardingUI
import NoticeFeatures
import PushNotifications
import ComposableArchitecture

@main
struct KuringApp: App {
    @State private var completesLink: Bool = false
    @State private var newNotice: Notice?
    @Environment(\.scenePhase) private var scenePhase

    // TODO: 테스트용 변수
    @State private var showsOnboarding: Bool = false
    @State private var didAppear: Bool = false
    
    @Dependency(\.commons) var commons
    @Dependency(\.swiftData) var swiftDataService
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var router = PushRouter.shared
    
    var modelContext: ModelContext {
        guard let modelContext = try? self.swiftDataService.context() else {
            fatalError("Could not find modelcontext")
        }
        return modelContext
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if completesLink {
                    // MARK: ContentView
                    NavigationStack {
                        ContentView(didAppear: $didAppear)
                    }
                    // MARK: 앱 업데이트 알림
                    .versionUpdateAlert()
                    // MARK: - 일주일 동안 공지를 확인하지 않았어요
                    .onChange(of: scenePhase) { scenePhase in
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
                } else {
                    // MARK: LaunchScreen
                    SplashScreen()
                        .kuringLink(
                            onRequest: { },
                            onCompletion: { result in
                                showsOnboarding = !commons.isOnboardingCompleted()
                                router.setReady()
                                if !showsOnboarding {
                                    completesLink = true
                                }
                            }
                        )
                }
            }
            // MARK: 새 공지 보여주기 (알림 탭했을 때)
            .fullScreenCover(item: $router.activeNotice) { notice in
                noticeDetailDestination(notice: notice)
            }
            .fullScreenCover(isPresented: $showsOnboarding) {
                completesLink = true
            } content: {
                OnboardingView()
            }
        }
        .modelContext(self.modelContext)
    }
    
    /// 공지사항 푸시알림 탭시 보여주는 View
    @ViewBuilder
    private func noticeDetailDestination(notice: Notice) -> some View {
        NavigationStack {
            NoticeDetailView(
                store: Store(
                    initialState: NoticeDetailFeature.State(notice: notice, isBookmarked: false),
                    reducer: { NoticeDetailFeature() }
                )
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { PushRouter.shared.activeNotice = nil } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}
