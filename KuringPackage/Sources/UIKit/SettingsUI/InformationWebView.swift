//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import SettingsFeatures
import ComposableArchitecture

public struct InformationWebView: View {
    @Bindable public var store: StoreOf<InformationWebFeature>

    public var body: some View {
        WebView(urlToLoad: store.url ?? URLLink.team.rawValue)
    }

    public init(store: StoreOf<InformationWebFeature>) {
        self.store = store
    }
}

#Preview {
    InformationWebView(
        store: Store(
            initialState: InformationWebFeature.State(),
            reducer: { InformationWebFeature() }
        )
    )
}
