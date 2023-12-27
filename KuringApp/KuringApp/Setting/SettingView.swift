//
//  SettingView.swift
//  KuringApp
//
//  Created by 박성수 on 2023/09/27.
//

import SwiftUI
import ComposableArchitecture

enum InformationURL: String {
    case kuringTeam = "https://bit.ly/3v2c5eg"
    case privacy = "https://kuring.notion.site/65ba27f2367044e0be7061e885e7415c"
    case policy = "https://kuring.notion.site/e88095d4d67d4c4c92983fd85cb693b9"
    case instagram = "https://instagram.com/kuring.konkuk"
}

@Reducer
struct SettingListFeature {
    @ObservableState
    struct State: Equatable {
        // TODO: 나중에 디펜던시로
        var currentAppIcon: KuringIcon?
        var isCustomAlarmOn: Bool = false
        
        @Presents var informationWebView: InformationWebViewFeature.State?
        @Presents var feedback: FeedbackFeature.State?
        
        
        init(currentAppIcon: KuringIcon? = nil) {
            @Dependency(\.appIcons) var appIcons
            self.currentAppIcon = currentAppIcon ?? appIcons.currentAppIcon
        }
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        // 알림 설정 관련
        case customAlarmToggle(Bool)
        
        // url 이동
        case urlButtonTapped(String)
        case informationWebView(PresentationAction<InformationWebViewFeature.Action>)
        
        // 피드백 작성
        case feedbackSelected
        case feedback(PresentationAction<FeedbackFeature.Action>)
        
        // 앱 벗어나는 액션
        case sns(String)
        
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case let .customAlarmToggle(value):
                state.isCustomAlarmOn = value
                return .none
                
                // 열어주는 역할
            case let .urlButtonTapped(url):
                state.informationWebView = InformationWebViewFeature.State(url: url)
                return .none
                
            case .feedbackSelected:
                state.feedback = FeedbackFeature.State()
                return .none
                
            case let .sns(url):
                guard let url = URL(string: url) else { return .none }
                UIApplication.shared.open(url)
                return .none
                
            case .binding, .informationWebView, .feedback:
                return .none
            }
        }
        // 서브도메인 경로 합치기
        .ifLet(\.$informationWebView, action: \.informationWebView) {
            InformationWebViewFeature()
        }
        .ifLet(\.$feedback, action: \.feedback) {
            FeedbackFeature()
        }
    }
}

struct SettingView: View {
    @Bindable var store: StoreOf<SettingListFeature>
    
    var body: some View {
        List {
            Section {
                Label("공지 구독하기", systemImage: "bell")
                
                HStack {
                    Label("기타 알림 받기", systemImage: "bell")
                    
                    Spacer()
                    
                    Toggle(isOn: $store.isCustomAlarmOn) {
                        Text("")
                    }
                    .labelsHidden()
                }
            } header: {
                Text("공지구독")
            }
            
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
                    
                    Text("1.4.1")
                }
                
                
                Button {
                    store.send(.urlButtonTapped(InformationURL.kuringTeam.rawValue))
                } label: {
                    Text("쿠링 팀")
                }
                .tint(.black)
                
                
                Button {
                    store.send(.urlButtonTapped(InformationURL.privacy.rawValue))
                } label: {
                    Text("개인정보 처리방침")
                }
                .tint(.black)
                
                
                Button {
                    store.send(.urlButtonTapped(InformationURL.policy.rawValue))
                } label: {
                    Text("서비스 이용약관")
                }
                .tint(.black)
                
                
                NavigationLink(
                    state: SettingsAppFeature.Path.State.openSourceList(
                        OpenSourceFeature.State()
                    )
                ) {
                    Text("사용된 오픈소스")
                }
            } header: {
                Text("정보")
            }
            
            Section {
                Button {
                    store.send(.sns(InformationURL.instagram.rawValue))
                } label: {
                    Text("인스타그램")
                }
                .tint(.black)
                
            } header: {
                Text("SNS")
            }
            
            Section {
                Button {
                    store.send(.feedbackSelected)
                } label: {
                    Label("피드백 보내기", systemImage: "bell")
                }
                
            } header: {
                Text("피드백")
            }
        }
        .navigationTitle("더보기")
        .sheet(
            store: self.store.scope(
                state: \.$feedback,
                action: \.feedback
            )
        ) { store in
            FeedbackView(store: store)
        }
        .sheet(
            store: self.store.scope(
                state: \.$informationWebView,
                action: \.informationWebView
            )
        ) { store in
            InformationWebView(store: store)
        }
    }
}


#Preview {
    NavigationStack {
        SettingView (
            store: Store(
                initialState: SettingListFeature.State(),
                reducer: { SettingListFeature() }
            )
        )
    }
}
