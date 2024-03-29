//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet
import SettingsFeatures
import ComposableArchitecture

public struct AppIconSelector: View {
    @Bindable var store: StoreOf<AppIconSelectorFeature>

    public var body: some View {
        List(store.appIcons) { icon in
            HStack {
                VStack {
                    Image(icon.rawValue, bundle: Bundle.settings)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .cornerRadius(10)
                        .shadow(radius: 0.5)
                }
                .padding(.trailing)

                Button {
                    store.send(.appIconSelected(icon))
                } label: {
                    Text(icon.korValue)
                        .foregroundStyle(Color.Kuring.body)
                }

                if icon == store.state.selectedIcon {
                    Spacer()

                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.tint)
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.Kuring.bg)
        }
        .background(Color.Kuring.bg)
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(.saveButtonTapped)
                } label: {
                    Text("저장")
                }
                .disabled(store.selectedIcon == store.currentIcon)
            }
        }
    }

    public init(store: StoreOf<AppIconSelectorFeature>) {
        self.store = store
    }
}

#Preview {
    AppIconSelector(
        store: Store(
            initialState: AppIconSelectorFeature.State(),
            reducer: { AppIconSelectorFeature() }
        )
    )
    .tint(Color.accentColor)
}
