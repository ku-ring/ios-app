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
    
    let onRequest: () -> Void
    let onCompletion: (Result<Void, Error>) -> Void
    
    func body(content: Content) -> some View {
        content
            .task {
                onRequest()
                do {
                    @Dependency(\.kuringLink) var kuringLink
                    let _ = try await kuringLink.getAllUnivNoticeType()
                    let _ = try await kuringLink.getAllDepartments()
                    let _ = try await kuringLink.getSubscribedDepartments()
                    let _ = try await kuringLink.getSubscribedUnivNotices()
                    onCompletion(.success(()))
                } catch {
                    showsNetworkError = true
                    onCompletion(.failure(error))
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

