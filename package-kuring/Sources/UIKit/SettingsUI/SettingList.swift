//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import SwiftUI
import ColorSet
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
                    itemView("icon_bell", "공지 구독하기")
                }

                HStack {
                    leadingItemView("icon_bell", "기타 알림 받기", "주요 공지사항, 앱 내 주요 사항")
                    
                    Spacer()
                    
                    Toggle("", isOn: $store.isCustomAlarmOn)
                        .labelsHidden()
                        .tint(Color.Kuring.primary)
                }
                
                Divider()
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            } header: {
                headerView("공지 구독")
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.Kuring.bg)
            
            Section {
                HStack(spacing: 0) {
                    leadingItemView("icon_rocket", "앱 버전")
                    Spacer()
                    Text("2.0.0")
                        .font(.system(size: 16, weight: .medium))
                        .kerning(0.15)
                        .foregroundStyle(Color.Kuring.body)
                }
                
                Button {
                    store.send(.delegate(.showWhatsNew))
                } label: {
                    itemView("icon_star", "새로운 내용")
                }

                Button {
                    store.send(.delegate(.showTeam))
                } label: {
                    itemView("icon_team", "쿠링 팀")
                }

                Button {
                    store.send(.delegate(.showPrivacyPolicy))
                } label: {
                    itemView("icon_guard", "개인정보 처리방침")
                }

                Button {
                    store.send(.delegate(.showTermsOfService))
                } label: {
                    itemView("icon_checkmark_circle", "서비스 이용약관")
                }
                
                Button {
                    store.send(.delegate(.showOpensourceList))
                } label: {
                    itemView("icon_opensource", "사용된 오픈소스")
                }
                
                Divider()
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            } header: {
                headerView("정보")
            } footer: {
                Text("Designed by 이소영, 김예은.\nDeveloped by 이재성, 이건우, 박성수.\nManaged by 조병관, 채수빈")
                    .font(.footnote)
                    .foregroundStyle(Color.Kuring.caption1)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.Kuring.bg)
            
            Section {
                ZStack {
                    NavigationLink(
                        state: SettingsAppFeature.Path.State.appIconSelector(
                            AppIconSelectorFeature.State()
                        )
                    ) {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    HStack(spacing: 0) {
                        Text("앱 아이콘 바꾸기")
                        Spacer()
                        Text(store.state.currentAppIcon?.korValue ?? KuringIcon.kuring_app.korValue)
                    }
                    .font(.system(size: 16, weight: .medium))
                    .kerning(0.15)
                    .foregroundStyle(Color.Kuring.body)
                }
                .padding(.vertical, 9)
                
                Divider()
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            } header: {
                headerView("쿠링 실험실")
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.Kuring.bg)
            
            Section {
                Button {
                    store.send(.delegate(.showInstagram))
                } label: {
                    itemView("icon_instagram", "인스타그램")
                }
                
                Divider()
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            } header: {
                headerView("SNS")
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.Kuring.bg)
            
            Section {
                Button {
                    store.send(.delegate(.showFeedback))
                } label: {
                    itemView("icon_feedback", "피드백 보내기")
                }
                
                Divider()
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            } header: {
                headerView("피드백")
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.Kuring.bg)
        }
        .listStyle(.plain)
        .background(Color.Kuring.bg)
        .navigationTitle("더보기")
        .navigationBarTitleDisplayMode(.inline)
    }

    public init(store: StoreOf<SettingListFeature>) {
        self.store = store
    }
    
    /// 섹션 헤더에 해당하는 뷰
    private func headerView(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 14))
            .foregroundStyle(Color.Kuring.caption2)
            .padding(.bottom, 8)
    }
    
    /// 아이콘 - 타이틀 - chevron 으로 구성
    private func itemView(_ imageName: String, _ title: String) -> some View {
        HStack(spacing: 0) {
            leadingItemView(imageName, title)
            Spacer()
            tailingChevronImage
        }
        .padding(.vertical, 9)
    }
    
    /// 아이콘 - 타이틀
    /// - note: 서브 타이틀이 존재하는 경우 파라미터에 넣어주기
    private func leadingItemView(
        _ imageName: String,
        _ title: String,
        _ subTitle: String? = nil
    ) -> some View {
        HStack(spacing: 0) {
            leadingIconImage(imageName: imageName)
                .padding(.trailing, 10)
            
            leadingTitle(title: title, subTitle: subTitle)
        }
    }
}

extension SettingList {
    /// 시스템 아이콘 이미지
    private func leadingSystemIconImage(systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .frame(width: 24, height: 24)
    }
    
    /// 아이콘 이미지
    private func leadingIconImage(imageName: String) -> some View {
        Image(imageName, bundle: .settings)
            .resizable()
            .frame(width: 24, height: 24)
    }
    
    /// 타이틀 및 서브 타이틀
    private func leadingTitle(title: String, subTitle: String? = nil) -> some View {
        VStack(alignment: .leading,
               spacing: 4) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .kerning(0.15)
                .foregroundStyle(Color.Kuring.body)
            
            if let subTitle = subTitle {
                Text(subTitle)
                    .font(.system(size: 12))
                    .kerning(0.15)
                    .foregroundStyle(Color.Kuring.caption1)
            }
        }
    }
    
    /// 우측 화살표 이미지
    private var tailingChevronImage: some View {
        Image("chevron", bundle: .settings)
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundStyle(Color.Kuring.gray300)
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
