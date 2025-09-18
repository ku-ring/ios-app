//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Networks
import Foundation
import ComposableArchitecture

public enum URLLink: String {
    case team = "https://bit.ly/3v2c5eg"
    case instagram = "https://instagram.com/kuring.konkuk"
    case terms = "https://kuring.notion.site/e88095d4d67d4c4c92983fd85cb693b9"
    case privacy = "https://kuring.notion.site/65ba27f2367044e0be7061e885e7415c"
    case whatsNew = "https://kuring.notion.site/iOS-eef51c986b7f4320b97424df3f4a5e3c"
}

@Reducer
public struct SettingListFeature {
    @ObservableState
    public struct State: Equatable {
        // TODO: 나중에 디펜던시로
        public var currentAppIcon: KuringIcon?
        public var isCustomAlarmOn: Bool = false
        @Presents public var alert: AlertState<Action.Alert>?

        public init(
            isCustomAlarmOn: Bool = true,
            appIcon: KuringIcon? = nil
        ) {
            self.isCustomAlarmOn = isCustomAlarmOn

            @Dependency(\.appIcons) var appIcons
            self.currentAppIcon = appIcon ?? appIcons.currentAppIcon
        }
    }

    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case onLogoutTapped
        /// 알림 관련 액션
        case alert(PresentationAction<Alert>)
        /// 알림
        public enum Alert: Equatable {
            /// 로그아웃 진행
            case logout
        }

        public enum Delegate: Equatable {
            case showSubscription
            case showWhatsNew
            case showTeam
            case showPrivacyPolicy
            case showTermsOfService
            case showInstagram
            case showFeedback
            case showOpensourceList
        }
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding, .delegate:
                return .none
            case .onLogoutTapped:
                state.alert = AlertState {
                    TextState("정말 로그아웃 하시겠어요?")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("취소하기")
                    }
                    
                    ButtonState(
                        role: .destructive,
                        action: .logout
                    ) {
                        TextState("취소하기")
                    }
                }
                return .none
            case let .alert(.presented(alertAction)):
                switch alertAction {
                case .logout:
                    @Dependency(\.kuringLink) var kuringLink
                    return .run { send in
                        do {
                            try await kuringLink.logout()
                        } catch {
                            print(error)
                        }
                    }
                    return .none
                }
            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }

    public init() { }
}
