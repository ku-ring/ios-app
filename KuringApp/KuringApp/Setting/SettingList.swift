//
//  SettingList.swift
//  KuringApp
//
//  Created by 이재성 on 12/29/23.
//

import Foundation
import ComposableArchitecture

enum URLLink: String {
    case team = "https://bit.ly/3v2c5eg"
    case instagram = "https://instagram.com/kuring.konkuk"
    case terms = "https://kuring.notion.site/e88095d4d67d4c4c92983fd85cb693b9"
    case privacy = "https://kuring.notion.site/65ba27f2367044e0be7061e885e7415c"
    case whatsNew = "https://kuring.notion.site/iOS-eef51c986b7f4320b97424df3f4a5e3c"
}

@Reducer
struct SettingListFeature {
    @ObservableState
    struct State: Equatable {
        // TODO: 나중에 디펜던시로
        var currentAppIcon: KuringIcon?
        var isCustomAlarmOn: Bool = false
        
        init(
            isCustomAlarmOn: Bool = true,
            appIcon: KuringIcon? = nil
        ) {
            self.isCustomAlarmOn = isCustomAlarmOn
            
            @Dependency(\.appIcons) var appIcons
            self.currentAppIcon = appIcon ?? appIcons.currentAppIcon
        }
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case showSubscription
            case showWhatsNew
            case showTeam
            case showPrivacyPolicy
            case showTermsOfService
            case showInstagram
            case showFeedback
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding, .delegate:
                return .none
            }
        }
    }
}


import SwiftUI

struct SettingList: View {
    @Bindable var store: StoreOf<SettingListFeature>
    
    var body: some View {
        List {
            Section {
                Button {
                    store.send(.delegate(.showSubscription))
                } label: {
                    Label("공지 구독하기", systemImage: "bell")
                }
                
                HStack {
                    Label("기타 알림 받기", systemImage: "bell")
                    
                    Spacer()
                    
                    Toggle("", isOn: $store.isCustomAlarmOn)
                        .labelsHidden()
                        .tint(Color.accentColor)
                }
            } header: {
                Text("공지구독")
            }
            .tint(.black)
            
            Section {
                NavigationLink(
                    state: SettingsAppFeature.Path.State.appIconSelector(
                        AppIconSelectorFeature.State()
                    )
                ) {
                    HStack {
                        Text("앱 아이콘 바꾸기")
                        
                        Spacer()
                        
                        Text(store.state.currentAppIcon?.korValue ?? KuringIcon.kuring_app.korValue)
                    }
                }
                
                HStack {
                    Text("앱 버전")
                    
                    Spacer()
                    
                    Text("2.0.0")
                }
                
                Button {
                    store.send(.delegate(.showTeam))
                } label: {
                    Text("쿠링 팀")
                }
                
                Button {
                    store.send(.delegate(.showPrivacyPolicy))
                } label: {
                    Text("개인정보 처리방침")
                }
                
                Button {
                    store.send(.delegate(.showTermsOfService))
                } label: {
                    Text("서비스 이용약관")
                }
                
                NavigationLink(
                    state: SettingsAppFeature.Path.State.openSourceList(
                        OpenSourceListFeature.State()
                    )
                ) {
                    Text("사용된 오픈소스")
                }
                
            } header: {
                Text("정보")
            }
            .tint(.black)
            
            Section {
                Button {
                    store.send(.delegate(.showInstagram))
                } label: {
                    Text("인스타그램")
                }
                
            } header: {
                Text("SNS")
            }
            .tint(.black)
            
            Section {
                Button {
                    store.send(.delegate(.showFeedback))
                } label: {
                    Label("피드백 보내기", systemImage: "bell")
                }
                
            } header: {
                Text("피드백")
            }
            .tint(.black)
        }
        .navigationTitle("더보기")
    }
}

#Preview {
    NavigationStack {
        SettingList (
            store: Store(
                initialState: SettingListFeature.State(),
                reducer: { SettingListFeature() }
            )
        )
    }
}
