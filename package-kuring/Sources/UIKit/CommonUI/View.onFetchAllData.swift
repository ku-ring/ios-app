//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import Networks
import Dependencies

struct KuringLinkFetcher: ViewModifier {
    @State private var showsNetworkError: Bool = false
    @Dependency(\.kuringLink) private var kuringLink
    
    @AppStorage("com.kuring.sdk.token.fcm.v2")
    var fcmToken: String = ""
    
    let onRequest: () -> Void
    let onCompletion: (Result<Void, Error>) -> Void
    
    func body(content: Content) -> some View {
        content
            .task {
                guard !fcmToken.isEmpty else { return }
                await request()
            }
            .onChange(of: fcmToken) { oldValue, newValue in
                // 앱 설치 초기에 뒤늦게 FCM 토큰을 발급 받는 경우
                guard !newValue.isEmpty else { return }
                Task { await request() }
                
                // 토큰 값이 다른 경우에만 해당 API 호출
                if oldValue != newValue {
                    Task(priority: .background) {
                        try? await kuringLink.registerAuthorization()
                    }
                }
                
            }
            .alert("앗! 인터넷 연결이 좋지 않아요!", isPresented: $showsNetworkError) {
                // 무시
                Button(role: .cancel) {
                    showsNetworkError = false
                } label: {
                    Text("이해했어요")
                }
            } message: {
                Text("네트워크 연결이 좋지 않아서 서버 정보를 불러오는데에 실패했어요.")
            }
    }
    
    func request() async {
        onRequest()
        do {
            @Dependency(\.kuringLink) var kuringLink
            async let allUnivNoticeTypes = try kuringLink.getAllUnivNoticeType()
            async let allDepartments = try kuringLink.getAllDepartments()
            let _ = try await [allUnivNoticeTypes, allDepartments]
            
            async let subscribedDepartments = try kuringLink.getSubscribedDepartments()
            async let subscribedUnivNotices = try kuringLink.getSubscribedUnivNotices()
            let _ = try? await [subscribedDepartments, subscribedUnivNotices]
            onCompletion(.success(()))
        } catch {
            onCompletion(.failure(error))
            showsNetworkError = true
        }
    }
}

extension View {
    /// 쿠링링크를 통해 서버에서 공지 카테고리와 구독 정보들을 가져옵니다.
    /// ```swift
    /// MyView()
    ///     .kuringLink {
    ///         // on request
    ///         showsProgressView = true
    ///     } onCompletion: { result in
    ///         showsProgressView = false
    ///         switch result {
    ///         case .success:
    ///             showsSuccessMark = true
    ///         case let .failure(error):
    ///             showsNetworkError = true
    ///         }
    ///     }
    /// ```
    public func kuringLink(
        onRequest: @escaping () -> Void,
        onCompletion: @escaping (Result<Void, Error>) -> Void
    ) -> some View {
        modifier(
            KuringLinkFetcher(
                onRequest: onRequest,
                onCompletion: onCompletion
            )
        )
    }
}

