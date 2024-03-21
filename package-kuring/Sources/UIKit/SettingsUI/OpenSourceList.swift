//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet
import SettingsFeatures
import ComposableArchitecture

public struct OpenSourceList: View {
    @Bindable public var store: StoreOf<OpenSourceListFeature>

    public var body: some View {
        List {
            ForEach(store.opensources) { opensource in
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(opensource.name)
                            .font(.title2.bold())
                        
                        HStack {
                            Rectangle()
                                .frame(width: 2, height: 15)
                                .padding(.vertical, 8)
                            
                            Text(opensource.purpose)
                                .font(.footnote)
                        }
                        .foregroundColor(.secondary)
                        
                        Button {
                            store.send(.linkTapped(opensource.github))
                        } label: {
                            HStack {
                                Text("GitHub 보기")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(ColorSet.primary)
                        
                        Text(opensource.license)
                            .font(.footnote)
                            .padding(.vertical, 8)
                    }
                }
            }
        }
        .listStyle(.plain)
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
