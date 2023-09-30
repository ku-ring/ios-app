//
//  AppIconSelectView.swift
//  KuringApp
//
//  Created by 박성수 on 2023/09/27.
//

import SwiftUI
import ComposableArchitecture

enum KuringIcon: String, CaseIterable {
    case kuring_app
    case kuring_app_classic
    case kuring_app_blueprint
    case kuring_app_sketch
    
    var korValue: String {
        switch self {
        case .kuring_app: return "쿠링 기본"
        case .kuring_app_classic: return "쿠링 클래식"
        case .kuring_app_blueprint: return "쿠링 블루프린트"
        case .kuring_app_sketch: return "쿠링 스케치"
        }
    }
}

struct AppIconSelect: Reducer {
    struct State: Equatable {
        var appIcons: [KuringIcon] = KuringIcon.allCases
        var selectedIcon: KuringIcon?
    }
    
    enum Action: Equatable {
        case appIconButtonTapped(tappedValue: KuringIcon)
        case saveButtonTapped
        
        // MARK: To SettingView
        case delegate(Delegate)
        enum Delegate: Equatable {
            case alternativeAppIconSave(KuringIcon)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .appIconButtonTapped(tappedValue: tappedValue):
                state.selectedIcon = tappedValue
                return .none
                
            case .saveButtonTapped:
                return .run { [selectedIcon = state.selectedIcon] send in
                    if await UIApplication.shared.supportsAlternateIcons {
                        DispatchQueue.main.async {
                            Task {
                                do {
                                    try await UIApplication.shared.setAlternateIconName(selectedIcon?.rawValue)
                                    send(.delegate(.alternativeAppIconSave(selectedIcon ?? KuringIcon.kuring_app)))
                                } catch let error {
                                    print(error.localizedDescription)
                                }
                                
                            }
                        }
                        
                    }
                }
                
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
            List(viewStore.appIcons, id: \.self) { icon in
                HStack {
                    VStack {
                        Image(uiImage: UIImage(named: icon.rawValue)!)
                            .resizable()
                            .frame(width: 70, height: 70)
                            .cornerRadius(10)
                    }
                    .padding(.trailing)
                    
                    Button {
                        viewStore.send(.appIconButtonTapped(tappedValue: icon))
                    } label: {
                        Text(icon.korValue)
                            .foregroundStyle(.black)
                    }
                    
                    if icon == viewStore.state.selectedIcon {
                        withAnimation {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewStore.send(.saveButtonTapped)
                    } label: {
                        Text("저장")
                    }
                }
            }
        }
    }
}

#Preview {
    AppIconSelectView(
        store: Store(
            initialState: 
                AppIconSelect.State(
                    selectedIcon: KuringIcon.kuring_app
                ),
            reducer: {
                AppIconSelect()
            }
        )
    )
}
