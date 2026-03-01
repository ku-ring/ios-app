//
//  ClubsList.swift
//  ClubsFeatures
//
//  Created by Jung Hwan Park on 3/1/26.
//

import Models
import Networks
import Dependencies
import ComposableArchitecture

@Reducer
public struct ClubsListFeature {
    @ObservableState
    public struct State: Equatable {
        public var selectedClubType: ClubsType = .all
        /// 동아리 목록
        public var clubsResult: ClubsResult?
        /// 동아리 소속 목록
        public var clubDivisions: ClubDivisions = .init(divisions: [])
        /// 선택된 동아리 카테고리
        public var selectedCategories: Set<Division> = []
        /// 동아리 카테고리 바텀시트
        public var showAffiliationSelectionSheet: Bool = false
        
        public init() { }
    }
    
    @Dependency(\.kuringLink) private var kuringLink

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        
        case onAppear
        /// 동아리 소속 목록을 조회한다
        case getClubDivisions
        case getClubDivisionsResponse(Result<ClubDivisions, ClubsKuringError>)
        
        /// 동아리 목록을 조회한다
        case getClubsList
        case getClubsListResponse(Result<ClubsResult, ClubsKuringError>)
        
        public enum Delegate: Equatable {
            /// 공지를 눌렀을 경우
            case showClubDetail(Club)
        }
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .concatenate([
                    .send(.getClubsList),
                    .send(.getClubDivisions)
                ])
            case .getClubsList:
                return .run { send in
                    do {
                        let result = try await kuringLink.getClubsList(.academic, nil, [], nil, nil)
                        await send(.getClubsListResponse(.success(result)))
                    } catch {
                        await send(.getClubsListResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case .getClubsListResponse(let result):
                switch result {
                case .success(let clubs):
                    state.clubsResult = clubs
                    return .none
                case .failure(let error):
                    print("Clubs error: \(error)")
                    return .none
                }
            case .getClubDivisions:
                return .run { send in
                    do {
                        let result = try await kuringLink.getClubDivisions()
                        await send(.getClubDivisionsResponse(.success(result)))
                    } catch {
                        await send(.getClubDivisionsResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case .getClubDivisionsResponse(let result):
                switch result {
                case .success(let divisions):
                    state.clubDivisions = divisions
                    return .none
                case .failure(let error):
                    print("Clubs error: \(error)")
                    return .none
                }
            default:
                return .none
            }
        }
    }

    public init() { }
}

