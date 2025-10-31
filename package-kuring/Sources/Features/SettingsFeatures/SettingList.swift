//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import SwiftUI
import Networks
import Foundation
import LoginFeatures
import ComposableArchitecture
import AcademicCalendarFeatures

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
        public var isAcademicScheduleAlarmOn: Bool = true
        public var email: String = "kuring@konkuk.ac.kr"
        public var nickname: String = "쿠링님"
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
        case onAppear
        case onLogoutTapped
        case clearUserInfo
        /// 알림 관련 액션
        case alert(PresentationAction<Alert>)
        case getUserInfoResponse(Result<UserInfo, LoginKuringError>)
        case toggleAcademicScheduleAlarm(Bool)
        case toggleAcademicScheduleAlarmResponse(Result<Bool, CalendarKuringError>)
        
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
    
    @Dependency(\.kuringLink) private var kuringLink
    @AppStorage("academicEventPush") var academicEventPush: Bool = true
    
    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.isAcademicScheduleAlarmOn):
                return .send(.toggleAcademicScheduleAlarm(state.isAcademicScheduleAlarmOn))
            case .binding, .delegate:
                return .none
            case .onAppear:
                @Dependency(\.kuringLink) var kuringLink
                return .run { send in
                    do {
                        let result = try await kuringLink.getUserInfo()
                        await send(.getUserInfoResponse(.success(result)))
                    } catch {
                        await send(.getUserInfoResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case let .getUserInfoResponse(result):
                switch result {
                case let .success(userInfo):
                    state.email = userInfo.email
                    state.nickname = userInfo.nickname
                    return .none
                case let .failure(error):
                    print(error)
                    return .none
                }
            case .clearUserInfo:
                state.email = "kuring@konkuk.ac.kr"
                state.nickname = "쿠링님"
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
                        TextState("로그아웃")
                    }
                }
                return .none
            case .toggleAcademicScheduleAlarm(let isOn):
                return .run { send in
                    do {
                        let result = try await kuringLink.setAcademicEventPush(isOn)
                        await send(.toggleAcademicScheduleAlarmResponse(.success(result)))
                    } catch {
                        await send(.toggleAcademicScheduleAlarmResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case .toggleAcademicScheduleAlarmResponse(let result):
                switch result {
                case .success(let success):
                    academicEventPush = !academicEventPush
                    return .none
                case .failure(let error):
                    print("Error: \(error)")
                    state.isAcademicScheduleAlarmOn.toggle()
                    return .none
                }
            case let .alert(.presented(alertAction)):
                switch alertAction {
                case .logout:
                    @Dependency(\.kuringLink) var kuringLink
                    return .run { send in
                        do {
                            try await kuringLink.logout()
                            await send(.clearUserInfo)
                            await send(.onAppear)
                        } catch {
                            print(error)
                        }
                    }
                }
            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }

    public init() { }
}
