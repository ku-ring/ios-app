//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import SettingsFeatures
import ComposableArchitecture

public struct OpenSourceList: View {
    @Bindable public var store: StoreOf<OpenSourceListFeature>

    public var body: some View {
        List(store.opensources) { opensource in
            VStack(alignment: .leading) {
                Text(opensource.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom)

                Button {
                    store.send(.linkTapped(opensource.link))
                } label: {
                    Text(opensource.link)
                }
                .tint(Color.accentColor)
            }
        }
    }

    public init(store: StoreOf<OpenSourceListFeature>) {
        self.store = store
    }
}

#Preview {
    OpenSourceList(
        store: Store(
            initialState: OpenSourceListFeature.State(),
            reducer: { OpenSourceListFeature() }
        )
    )
}
