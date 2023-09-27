//
//  AppIconSelectView.swift
//  KuringApp
//
//  Created by 박성수 on 2023/09/27.
//

import SwiftUI
import ComposableArchitecture

struct AppIconSelect: Reducer {
    struct State: Equatable {
        var appIcons: [String] = ["kuring.app.blueprint", "kuring.app.classic", "kuring.app", "kuring.app.sketch"]
        var selectedIcon: String?
    }
    
    enum Action: Equatable {
        case appIconButtonTapped(tappedValue: String)
        case saveButtonTapped
        
        // MARK: To SettingView
        case delegate(Delegate)
        enum Delegate: Equatable {
            case appIconChanged(String)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .appIconButtonTapped(tappedValue: tappedValue):
                state.selectedIcon = tappedValue
                return .send(.delegate(.appIconChanged(tappedValue)))
            case .saveButtonTapped:
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}

struct AppIconSelectView: View {
    let store: StoreOf<AppIconSelect>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(viewStore.state.appIcons, id: \.self) { iconText in
                    Text(iconText)
                        .background(
                            Rectangle()
                                .foregroundColor(viewStore.state.selectedIcon == iconText ? .green : .red)
                        )
                        .onTapGesture {
                            viewStore.send(.appIconButtonTapped(tappedValue: iconText))
                        }
                }
            }
            Image(viewStore.state.selectedIcon!)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
                
        }
    }
}

#Preview {
    AppIconSelectView(
        store: Store(
            initialState: AppIconSelect.State(),
            reducer: { AppIconSelect() }
        )
    )
}
