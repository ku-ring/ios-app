//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import SwiftUI
import SettingsFeatures
import ComposableArchitecture

public struct SettingList: View {
    @Bindable public var store: StoreOf<SettingListFeature>
    @Dependency(\.leLabo) var leLabo
    
    struct Constants {
        static let TextCaption2: Color = Color(red: 0.7, green: 0.71, blue: 0.74)
        static let TextBody: Color = Color(red: 0.21, green: 0.24, blue: 0.29)
    }
    
    public var body: some View {
        List {
            Section {
                Button {
                    store.send(.delegate(.showSubscription))
                } label: {
                    itemView("icon_bell", "공지 구독하기")
                }

                HStack {
                    itemView("icon_bell", "기타 알림 받기")

                    Spacer()

                    Toggle("", isOn: $store.isCustomAlarmOn)
                        .labelsHidden()
                        .tint(Color.accentColor)
                }
            } header: {
                headerView("공지 구독")
            }
            .tint(.black)
            .listRowSeparator(.hidden)

            Section {
                HStack {
                    Text("앱 버전")

                    Spacer()

                    Text("2.0.0")
                }
                
                Button {
//                    store.send(.delegate(.showTeam))
                } label: {
                    itemView("icon_new", "새로운 내용")
                }

                Button {
                    store.send(.delegate(.showTeam))
                } label: {
                    itemView("icon_team", "쿠링 팀")
                }

                Button {
                    store.send(.delegate(.showPrivacyPolicy))
                } label: {
                    itemView("icon_private", "개인정보 처리방침")
                }

                Button {
                    store.send(.delegate(.showTermsOfService))
                } label: {
                    itemView("icon_service", "서비스 이용약관")
                }

                NavigationLink(
                    state: SettingsAppFeature.Path.State.openSourceList(
                        OpenSourceListFeature.State()
                    )
                ) {
                    itemView("icon_opensource", "오픈소스 라이센스")
                }
            } header: {
                headerView("정보")
            } footer: {
                Text("Designed by 이소영, 김예은.\nDeveloped by 이재성, 이건우, 박성수.\nManaged by 조병관, 채수빈")
                    .font(.footnote)
            }
            .tint(.black)
            .listRowSeparator(.hidden)
            
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
                headerView("쿠링 실험실")
            }
            .listRowSeparator(.hidden)

            Section {
                Button {
                    store.send(.delegate(.showInstagram))
                } label: {
                    itemView("icon_instagram", "인스타그램")
                }

            } header: {
                headerView("SNS")
            }
            .tint(.black)
            .listRowSeparator(.hidden)
            
            Section {
                Button {
                    store.send(.delegate(.showFeedback))
                } label: {
                    itemView("icon_feedback", "피드백 보내기")
                }
            } header: {
                headerView("피드백")
            }
            .tint(.black)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationTitle("더보기")
        .navigationBarTitleDisplayMode(.inline)
    }

    public init(store: StoreOf<SettingListFeature>) {
        self.store = store
    }
    
    /// 섹션 헤더에 해당하는 뷰
    private func headerView(_ title: String) -> some View {
        Text(title)
            .font(Font.custom("Pretendard", size: 14))
            .foregroundColor(Constants.TextCaption2)
            .padding(.top, 12)
            .padding(.bottom, 8)
    }
    
    /// 섹션 아이템에 해당하는 뷰
    private func itemView(_ imageName: String, _ title: String) -> some View {
        HStack(alignment: .center,
               spacing: 0) {
            Image(imageName, bundle: Bundle.settings)
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(
                    Font.custom("Pretendard", size: 16)
                        .weight(.medium)
                )
                .kerning(0.15)
                .foregroundColor(Constants.TextBody)
                .padding(.leading, 10)
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
               .padding(.vertical, 9)
    }
}

#Preview {
    NavigationStack {
        SettingList(
            store: Store(
                initialState: SettingListFeature.State(),
                reducer: { SettingListFeature() }
            )
        )
    }
}
