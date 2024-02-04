//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import Networks
import Dependencies

/// 최소 지원 버전보다 낮은 경우 업데이트 알림을 띄웁니다.
/// ```swift
/// MyView()
///     .versionUpdateAlert()
/// ```
struct VersionUpdateAlert: ViewModifier {
    @State private var showsUpdateAlert: Bool = false
    @Dependency(\.appSupport) var appSupport
    
    func body(content: Content) -> some View {
        content
            .task {
                do {
                    showsUpdateAlert = try await appSupport.isAppVersionDeprecated(
                        KuringLink.appVersion
                    )
                } catch {
                    showsUpdateAlert = false
                }
            }
            .alert("업데이트가 필요합니다", isPresented: $showsUpdateAlert) {
                // 무시
                Button(role: .cancel) {
                    showsUpdateAlert = false
                } label: {
                    Text("무시하기")
                }
                
                // 업데이트로 연결
                Button {
                    defer { showsUpdateAlert = false }
                    guard let url = URL(string: "itms-apps://itunes.apple.com/app/1609873520") else { return }
                    guard UIApplication.shared.canOpenURL(url) else { return }
                    UIApplication.shared.open(url)
                } label: {
                    Text("업데이트")
                }
            } message: {
                Text("업데이트를 하지 않는 경우 예상치 못한 에러가 발생할 수 있습니다.")
            }
    }
}

extension View {
    /// 현재 앱 버전이 만료되었는지 확인하여 만료된 버전의 경우 업데이트 권장 알림을 띄웁니다.
    /// - Note: 쿠링 앱의 최소 지원버전을 가져와서 비교합니다.
    /// ```swift
    /// MyView()
    ///     // 현재 버전이 만료된 버전이면 업데이트 권장 알림 띄움
    ///     .versionUpdateAlert()
    /// ```
    func versionUpdateAlert() -> some View {
        modifier(VersionUpdateAlert())
    }
}

#Preview {
    Text("잠시만요")
        .versionUpdateAlert()
}
