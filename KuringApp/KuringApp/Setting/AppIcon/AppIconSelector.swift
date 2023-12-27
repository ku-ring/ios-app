//
//  AppIconSelector.swift
//  KuringApp
//
//  Created by 박성수 on 2023/09/27.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AppIconSelectorFeature {
    @ObservableState
    struct State: Equatable {
        var appIcons: IdentifiedArrayOf<KuringIcon> = IdentifiedArray(uniqueElements: KuringIcon.allCases)
        var selectedIcon: KuringIcon?
        var currentIcon: KuringIcon
        
        init(
            appIcons: IdentifiedArrayOf<KuringIcon> = IdentifiedArray(uniqueElements: KuringIcon.allCases),
            selectedIcon: KuringIcon? = nil
        ) {
            @Dependency(\.appIcons) var appIconClient
            self.appIcons = appIcons
            self.selectedIcon = selectedIcon ?? appIconClient.currentAppIcon
            self.currentIcon = appIconClient.currentAppIcon
        }
    }
    
    enum Action: Equatable {
        /// 앱 아이콘 선택
        case appIconSelected(KuringIcon)
        /// 앱 아이콘 저장하기 버튼
        case saveButtonTapped
        
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case completeAppIconChange
        }
    }
    
    @Dependency(\.appIcons) var appIcons
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .appIconSelected(icon):
                state.selectedIcon = icon
                return .none
                
            case .saveButtonTapped:
                return .run { [selectedIcon = state.selectedIcon] send in
                    guard let selectedIcon else { return }
                    await appIcons.changeTo(selectedIcon)
                    await send(.delegate(.completeAppIconChange))
                }
                
            case .delegate:
                return .none
            }
        }
    }
}

struct AppIconSelector: View {
    @Bindable var store: StoreOf<AppIconSelectorFeature>
    
    var body: some View {
        List(store.appIcons) { icon in
            HStack {
                VStack {
                    Image(uiImage: UIImage(named: icon.rawValue)!)
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
