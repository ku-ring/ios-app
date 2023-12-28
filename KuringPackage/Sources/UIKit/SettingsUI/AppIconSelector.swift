import SwiftUI
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
                        .foregroundStyle(.black)
                }
                
                if icon == store.state.selectedIcon {
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.tint)
                }
            }
        }
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
