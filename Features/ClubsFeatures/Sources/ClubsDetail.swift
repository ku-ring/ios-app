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
        public var club: Club
        public var clubDetail: ClubDetail?
        
        public init(club: Club) {
            self.club = club
        }
    }

    @Dependency(\.kuringLink) private var kuringLink
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        /// 동아리 상세 조회
        case getClubDetail
        case getClubDetailResponse(Result<ClubDetail, ClubsKuringError>)
        
        /// 동아리 즐겨찾기
        case subscribeToClub(id: Int, isSubscribed: Bool)
        case subscribeToClubResponse(Result<ClubBookmarkCountResponse, ClubsKuringError>)
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
                        await send(.subscribeToClubResponse(.success(response)))
                    } catch {
                        await send(.subscribeToClubResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case .subscribeToClubResponse:
                state.club.isSubscribed.toggle()
                return .none
            default:
                return .none
            }
        }
    }

    public init() { }
}
