//
//  ClubsDetail.swift
//  ClubsFeatures
//
//  Created by Jung Hwan Park on 3/1/26.
//

import Models
import Networks
import Foundation
import Dependencies
import ComposableArchitecture

@Reducer
public struct ClubsDetailFeature {
    @ObservableState
    public struct State: Equatable {
        @Presents public var alert: AlertState<Action.Alert>?
        
        public var club: Club
        public var clubDetail: ClubDetail?
        
        public init(club: Club) {
            self.club = club
        }
    }

    @Dependency(\.kuringLink) private var kuringLink
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        
        /// 동아리 상세 조회
        case getClubDetail
        case getClubDetailResponse(Result<ClubDetail, ClubsKuringError>)
        
        /// 동아리 즐겨찾기
        case subscribeToClub(id: Int, isSubscribed: Bool)
        case subscribeToClubResponse(Result<ClubSubscriptionCountResponse, ClubsKuringError>, Int)
        
        case showNeedsLoginAlert
        /// 알림 관련 액션
        case alert(PresentationAction<Alert>)
        
        public enum Delegate: Equatable {
            /// 미로그인 시 로그인 화면으로 이동
            case pushToLogin
            case subscriptionChanged(clubId: Int, isSubscribed: Bool)
        }
        
        /// 알러트
        public enum Alert: Equatable {
            case pushToLogin
        }
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .getClubDetail:
                return .run { [id = state.club.id] send in
                    do {
                        let result = try await kuringLink.getClubDetail(id)
                        await send(.getClubDetailResponse(.success(result)))
                    } catch {
                        await send(.getClubDetailResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case .getClubDetailResponse(let result):
                switch result {
                case .success(let clubDetail):
                    state.clubDetail = clubDetail
                    return .none
                case .failure(let error):
                    print("Clubs error: \(error)")
                    return .none
                }
            case .subscribeToClub(let id, let isSubscribed):
                return .run { send in
                    do {
                        let response = isSubscribed ? try await kuringLink.unsubscribeToClub(id) : try await kuringLink.subscribeToClub(id)
                        await send(.subscribeToClubResponse(.success(response), id))
                    } catch {
                        await send(.subscribeToClubResponse(.failure(.error(error.localizedDescription)), id))
                    }
                }
            case .subscribeToClubResponse(let result, let id):
                switch result {
                case .success(let response):
                    state.club.subscriberCount = response.subscriptionCount
                    state.club.isSubscribed.toggle()
                    return .send(.delegate(.subscriptionChanged(
                        clubId: id,
                        isSubscribed: state.club.isSubscribed
                    )))
                case .failure(let error):
                    print(error.localizedDescription)
                }
                return .none
            case .showNeedsLoginAlert:
                state.alert = AlertState {
                    TextState("로그인이 필요한 서비스에요")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("취소")
                    }
                    
                    ButtonState(
                        role: .destructive,
                        action: .pushToLogin
                    ) {
                        TextState("로그인하기")
                    }
                }
                return .none
            case .alert(.presented(.pushToLogin)):
                state.alert = nil
                return .send(.delegate(.pushToLogin))
            case .alert(.dismiss):
                state.alert = nil
                return .none
            default:
                return .none
            }
        }
    }

    public init() { }
}
