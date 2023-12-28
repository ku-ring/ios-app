//
//  SettingsApp.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/10/06.
//

import SwiftUI
import SubscriptionFeatures
import ComposableArchitecture

@Reducer
struct SettingsAppFeature {
    @ObservableState
    struct State: Equatable {
        /// 트리 기반 네비게이션 Path
        @Presents var destination: Destination.State?
        /// 스택 기반 네비게이션 Path
        var path = StackState<Path.State>()
        /// Root
        var settingList = SettingListFeature.State()
        
        init(
            destination: Destination.State? = nil,
            path: StackState<Path.State> = .init(),
            root: SettingListFeature.State = .init()
        ) {
            // 디펜던시로 세팅
            self.destination = destination
            self.path = path
        }
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        /// Root
        case settingList(SettingListFeature.Action)
        /// 스택 기반 네비게이션 Path
        case path(StackAction<Path.State, Path.Action>)
        /// 트리기반 네비게이션 Destination
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.settingList, action: \.settingList) {
            SettingListFeature()
        }
    
        Reduce { state, action in
            switch action {
            case let .settingList(.delegate(action)):
                switch action {
                case .showSubscription:
                    state.destination = .subscription(SubscriptionAppFeature.State())
                    return .none
                    
                case .showWhatsNew:
                    state.destination = .informationWeb(
                        InformationWebViewFeature.State(url: URLLink.whatsNew.rawValue)
                    )
                    return .none
                    
                case .showTeam:
                    state.destination = .informationWeb(
                        InformationWebViewFeature.State(url: URLLink.team.rawValue)
                    )
                    return .none
                    
                case .showPrivacyPolicy:
                    state.destination = .informationWeb(
                        InformationWebViewFeature.State(url: URLLink.privacy.rawValue)
                    )
                    return .none
                    
                case .showTermsOfService:
                    state.destination = .informationWeb(
                        InformationWebViewFeature.State(url: URLLink.terms.rawValue)
                    )
                    return .none
                    
                case .showInstagram:
                    state.destination = .informationWeb(
                        InformationWebViewFeature.State(url: URLLink.instagram.rawValue)
                    )
                    return .none
                    
                case .showFeedback:
                    state.destination = .feedback(FeedbackFeature.State())
                    return .none
                }
                
            case let .path(.element(id: id, action: .appIconSelector(.delegate(.completeAppIconChange)))):
                guard case let .appIconSelector(appIconSelectorState) = state.path[id: id] else {
                    return .none
                }
                state.settingList.currentAppIcon = appIconSelectorState.selectedIcon
                state.path.pop(from: id)
                return .none
            
            case .binding:
                return .none
            
            case .destination, .path:
                return .none
                
            case .settingList:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}

import SubscriptionUI

struct SettingsApp: View {
    @Bindable var store: StoreOf<SettingsAppFeature>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            SettingList(
                store: store.scope(state: \.settingList, action: \.settingList)
            )
        } destination: { store in
            switch store.state {
            case .appIconSelector:
                if let store = store.scope(state: \.appIconSelector, action: \.appIconSelector) {
                    AppIconSelector(store: store)
                        .navigationTitle("앱 아이콘")
                }
            case .openSourceList:
                if let store = store.scope(state: \.openSourceList, action: \.openSourceList) {
                    OpenSourceList(store: store)
                        .navigationTitle("사용된 오픈소스")
                }
            }
        }
        .sheet(
            store: self.store.scope(
                state: \.$destination.subscription,
                action: \.destination.subscription
            )
        ) { store in
            SubscriptionApp(store: store)
        }
        .sheet(
            store: self.store.scope(
                state: \.$destination.feedback,
                action: \.destination.feedback
            )
        ) { store in
            FeedbackView(store: store)
        }
        .sheet(
            store: self.store.scope(
                state: \.$destination.informationWeb,
                action: \.destination.informationWeb
            )
        ) { store in
            InformationWebView(store: store)
        }
    }
}

#Preview {
    SettingsApp(
        store: Store(
            initialState: SettingsAppFeature.State(),
            reducer: { SettingsAppFeature() }
        )
    )
}
