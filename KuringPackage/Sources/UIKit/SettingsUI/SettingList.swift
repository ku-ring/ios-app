import Caches
import SwiftUI
import SettingsFeatures
import ComposableArchitecture

public struct SettingList: View {
    @Bindable public var store: StoreOf<SettingListFeature>
    @Dependency(\.leLabo) var leLabo
    
    public var body: some View {
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
            } footer: {
                Text("Designed by 이소영, 김예은.\nDeveloped by 이재성, 이건우, 박성수.\nManaged by 조병관, 채수빈")
            }
            .tint(.black)
            
            Section {
                Button {
                    store.send(.delegate(.showLabs))
                } label: {
                    Label("쿠링 실험실", systemImage: "flask")
                }
                
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
            } header: {
                Text("쿠링 실험실")
            }
            
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
        .navigationBarTitleDisplayMode(.inline)
    }
    
    public init(store: StoreOf<SettingListFeature>) {
        self.store = store
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
