//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet
import KuringMapsUI

public struct CampusApp: View {
    private let appearance = Appearance(
        tint: Color.Kuring.primary,
        primary: Color.Kuring.body,
        secondary: Color.Kuring.caption1,
        background: Color.Kuring.bg,
        secondaryBackground: Color.Kuring.gray100,
        link: Color.Kuring.primary,
        body: .system(size: 16),
        title: .system(size: 20),
        subtitle: .system(size: 16),
        footnote: .system(size: 14),
        caption: .system(size: 12)
    )
    
    private var linkHost: String {
        guard let plistURL = Bundle.module.url(forResource: "KuringMaps-Info", withExtension: "plist") else {
            return ""
        }
        let dict = try? NSDictionary(contentsOf: plistURL, error: ())
        let apiHost = dict?["API_HOST"] as? String
        return apiHost ?? ""
    }
    private var libHost: String {
        guard let plistURL = Bundle.module.url(forResource: "KuringMaps-Info", withExtension: "plist") else {
            return ""
        }
        let dict = try? NSDictionary(contentsOf: plistURL, error: ())
        let libraryConfig = dict?["Library Configuration"] as? [String: String]
        let apiHost = libraryConfig?["API_HOST"]
        return apiHost ?? ""
    }
    
    public var body: some View {
        KuringMap(
            linkConfig: .init(host: linkHost),
            libConfig: .init(host: libHost)
        )
        .environment(\.mapAppearance, appearance)
    }
    
    public init() { }
}

#Preview {
    TabView {
        CampusApp()
            .tabItem {
                Text("캠퍼스맵")
            }
    }
}
