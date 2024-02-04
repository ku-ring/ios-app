//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import Networks
import Dependencies

/// 최소 지원 버전보다 낮은 경우 업데이트 알림을 띄웁니다.
struct VersionUpdateAlert: ViewModifier {
    /// 테스트를 위한 프로퍼티 입니다.
    let appVersion: String
    
    @State private var showsUpdateAlert: Bool = false
    @Dependency(\.appSupport) var appSupport
    
    private let appStoreLink = "itms-apps://itunes.apple.com/app/1609873520"
    
    func body(content: Content) -> some View {
        content
            .task {
                do {
                    showsUpdateAlert = try await appSupport.isAppVersionDeprecated(
                        appVersion
                    )
                } catch {
                    showsUpdateAlert = false
                }
            }
            .alert("업데이트가 필요해요", isPresented: $showsUpdateAlert) {
                // 무시
                Button(role: .cancel) {
                    showsUpdateAlert = false
                } label: {
                    Text("나중에")
                }
                
                // 앱스토어 페이지로 연결
                Button {
                    defer { showsUpdateAlert = false }
                    guard let url = URL(string: appStoreLink) else { return }
                    guard UIApplication.shared.canOpenURL(url) else { return }
                    UIApplication.shared.open(url)
                } label: {
                    Text("업데이트")
                }
            } message: {
                Text("업데이트를 진행하여 더욱 안정적이고\n편리한 서비스를 이용해 보세요")
            }
    }
}

extension View {
    /// 현재 앱 버전이 만료되었는지 확인하여 만료된 버전의 경우 업데이트 권장 알림을 띄웁니다.
    /// - Note: 쿠링 앱의 최소 지원버전을 가져와서 비교합니다.
    /// - Parameter appVersion: 최소 버전과 비교할 앱 버전. 기본값은 `KuringLink.appVersion`.
    /// ```swift
    /// MyView()
    ///     // 현재 버전이 만료된 버전이면 업데이트 권장 알림 띄움
    ///     .versionUpdateAlert()
    /// ```
    public func versionUpdateAlert(appVersion: String = KuringLink.appVersion) -> some View {
        modifier(VersionUpdateAlert(appVersion: appVersion))
    }
}

#Preview {
    Text("잠시만요")
        .versionUpdateAlert(appVersion: "1.9.0")
}
