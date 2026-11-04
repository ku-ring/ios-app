//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation
import AmplitudeSwift
import Dependencies

/// 쿠링 앱에서 로깅하는 Amplitude 이벤트 종류
public enum AnalyticsEvent: String {
    /// 공지사항 홈 화면에 진입했을 때
    case noticeHomeView = "notice_home_view"
    /// 학사일정 캘린더 화면에 진입했을 때
    case calendarView = "calendar_view"
    /// 쿠링맵 화면에 진입했을 때
    case mapView = "map_view"
    /// 동아리 탭 화면에 진입했을 때
    case clubTabView = "club_tab_view"
    /// 푸시알림 설정 화면에 진입했을 때
    case pushSettingView = "push_setting_view"
    /// 쿠링봇 아이콘을 눌러 화면에 진입했을 때
    case botView = "bot_view"
}

fileprivate var amplitudeAPIKey: String {
    guard let plistURL = Bundle.module.url(forResource: "Analytics-Info", withExtension: "plist") else {
        return ""
    }
    let dict = try? NSDictionary(contentsOf: plistURL, error: ())
    return dict?["AMPLITUDE_API_KEY"] as? String ?? ""
}

fileprivate let amplitude: Amplitude = {
    let configuration = Configuration(apiKey: amplitudeAPIKey)
    return Amplitude(configuration: configuration)
}()

public struct AnalyticsClient {
    public var track: (_ event: AnalyticsEvent, _ properties: [String: Any]) -> Void
}

extension AnalyticsClient {
    public func track(_ event: AnalyticsEvent) {
        track(event, [:])
    }
}

extension AnalyticsClient: DependencyKey {
    public static let liveValue = Self(
        track: { event, properties in
            amplitude.track(eventType: event.rawValue, eventProperties: properties)
        }
    )
}

extension AnalyticsClient: TestDependencyKey {
    public static var previewValue = Self.noop

    public static let testValue = Self(
        track: unimplemented("\(Self.self).track")
    )

    public static let noop = Self(
        track: { _, _ in }
    )
}

extension DependencyValues {
    public var analytics: AnalyticsClient {
        get { self[AnalyticsClient.self] }
        set { self[AnalyticsClient.self] = newValue }
    }
}
