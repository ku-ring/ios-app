//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import KuringMapsUI

public struct CampusApp: View {
    private let appearance = Appearance()
    
    public var body: some View {
        KuringMap(
            linkConfig: .init(host: ""),
            libConfig: .init(host: "")
        )
        .environment(\.mapAppearance, appearance)
    }
    
    public init() {
        
    }
}

#Preview {
    TabView {
        CampusApp()
            .tabItem {
                Text("캠퍼스맵")
            }
    }
}
