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
    case kakao = "https://apps.apple.com/kr/app/%EC%BF%A0%EB%A7%81-%EA%B1%B4%EA%B5%AD%EB%8C%80%ED%95%99%EA%B5%90-%EA%B3%B5%EC%A7%80%EC%95%B1/id1609873520"
}

struct SettingListFeature: Reducer {
    
    struct State: Equatable {
        // TODO: 나중에 디펜던시로
        var currentAppIcon: KuringIcon?
        
        @PresentationState var feedbackViewPresent: FeedbackFeature.State?
        @PresentationState var webViewOpen: InformationWebViewFeature.State?
        
        
        init(currentAppIcon: KuringIcon? = nil) {
            @Dependency(\.appIcons) var appIcons
            
            self.currentAppIcon = currentAppIcon ?? appIcons.currentAppIcon
        }
    }
    
    enum Action: Equatable {
        // url 이동
        case urlButtonTapped(String)
        case eraseWebView(PresentationAction<InformationWebViewFeature.Action>)
        
        // 피드백 작성
        case feedbackViewPresent
        case eraseFeedbackView(PresentationAction<FeedbackFeature.Action>)
        
        // 앱 벗어나는 액션
        case sns(String)
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
                // 열어주는 역할만
            case .urlButtonTapped(let url):
                state.webViewOpen = InformationWebViewFeature.State(url: url)
                return .none
                
                // 뷰 지워주는 역할만
            case let .eraseWebView(.presented(.delegate(action))):
                switch action {
                case .erase:
                    state.webViewOpen = nil
                    return .none
                }
                
            case .feedbackViewPresent:
                state.feedbackViewPresent = FeedbackFeature.State()
                return .none
                
            case let .eraseFeedbackView(.presented(.delegate(action))):
                switch action {
                case .erase:
                    state.feedbackViewPresent = nil
                    return .none
                }
                
            case let .sns(url):
                UIApplication.shared.open(URL(string: url)!, options: [:])
                return .none
                
                
            default:
                return .none
            }
        }
        .ifLet(\.$webViewOpen, action: /Action.eraseWebView) {
            InformationWebViewFeature()
        }
        .ifLet(\.$feedbackViewPresent, action: /Action.eraseFeedbackView) {
            FeedbackFeature()
        }
    }
}

struct SettingView: View {
    let store: StoreOf<SettingListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List {
                Section {
                    Label("공지 구독하기", systemImage: "bell")
                    
                    HStack {
                        Label("기타 알림 받기", systemImage: "bell")
                        Spacer()
                        Toggle(isOn: .constant(true)) {
                            Text("")
                        }
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
                            
                            Text(viewStore.state.currentAppIcon?.korValue ?? KuringIcon.kuring_app.korValue)
                        }
                    }
                    
                    HStack {
                        Text("앱 버전")
                        
                        Spacer()
                        
                        Text("1.4.1")
                    }
                    
                    
                    Button(action: {
                        viewStore.send(.urlButtonTapped(InformationURL.kuringTeam.rawValue))
                    }, label: {
                        Text("쿠링 팀")
                    }).tint(.black)
                    
                    
                    Button(action: {
                        viewStore.send(.urlButtonTapped(InformationURL.privacy.rawValue))
                        
                    }, label: {
                        Text("개인정보 처리방침")
                    }).tint(.black)
                    
                    
                    Button(action: {
                        viewStore.send(.urlButtonTapped(InformationURL.policy.rawValue))
                        
                    }, label: {
                        Text("서비스 이용약관")
                    }).tint(.black)
                    
                    
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
                    Button(action: {
                        viewStore.send(.sns(InformationURL.instagram.rawValue))
                    }, label: {
                        Text("인스타그램")
                    }).tint(.black)
                    
                    
                    Button(action: {
                        viewStore.send(.sns(InformationURL.kakao.rawValue))
                    }, label: {
                        Text("카카오톡 채널")
                    }).tint(.black)
                    
                } header: {
                    Text("SNS")
                }
                
                Section {
                    Button(action: {
                        viewStore.send(.feedbackViewPresent)
                    }, label: {
                        Label("피드백 보내기", systemImage: "bell")
                    })
                    
                } header: {
                    Text("피드백")
                }
            }
            .navigationTitle("더보기")
            .sheet(
                store: self.store.scope(
                    state: \.$feedbackViewPresent,
                    action: { .eraseFeedbackView($0) }
                )
            ) { store in
                FeedbackView(store: store)
            }
            .sheet(
                store: self.store.scope(
                    state: \.$webViewOpen,
                    action: { .eraseWebView($0) }
                )
            ) { store in
                InformationWebView(store: store)
            }
        }
    }
}


#Preview {
    NavigationStack {
        SettingView (
            store: Store(
                initialState: SettingListFeature.State(),
                reducer: { SettingListFeature()
                }
            )
        )
    }
}
