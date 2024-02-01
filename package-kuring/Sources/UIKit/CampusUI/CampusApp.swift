//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import KuringMapsUI

public struct CampusApp: View {
    private let appearance = Appearance()
    
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
