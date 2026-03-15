//
//  ClubsList.swift
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
public struct ClubsListFeature {
    @ObservableState
    public struct State: Equatable {
        @Presents public var alert: AlertState<Action.Alert>?
        
        public var selectedClubType: ClubsType = .all
        /// 동아리 목록 (원본 데이터)
        public var originalClubs: ClubsResult?
        /// 동아리 목록 (화면에 보여줄 최종 데이터)
        public var filteredClubs: ClubsResult?
        /// 동아리 소속 목록
        public var clubDivisions: ClubDivisions = .init(divisions: ClubDivisions.allCases)
        /// 선택된 동아리 카테고리
        public var selectedCategories: Set<Division> = []
        /// 동아리 카테고리 바텀시트
        public var showDivisionSelectionSheet: Bool = false
        /// 동아리 목록 정렬 기준
        public var sortType: SortType = .deadline
        
        public enum SortType: Equatable {
            case deadline
            case alphabetical
        }
        
        public init() { }
    }
    
    @Dependency(\.kuringLink) private var kuringLink

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        
        case changeSortBy(by: State.SortType)
        case applyFiltersAndSort
        case onAppear
        /// 동아리 소속 목록을 조회한다
        case getClubDivisions
        case getClubDivisionsResponse(Result<ClubDivisions, ClubsKuringError>)
        
        /// 동아리 목록을 조회한다
        case getClubsList
        case getClubsListResponse(Result<ClubsResult, ClubsKuringError>)
        
        /// 동아리 즐겨찾기
        case subscribeToClub(id: Int, isSubscribed: Bool)
        case subscribeToClubResponse(Result<ClubBookmarkCountResponse, ClubsKuringError>, Int)
        
        case showNeedsLoginAlert
        /// 알림 관련 액션
        case alert(PresentationAction<Alert>)
        
        public enum Delegate: Equatable {
            /// 공지를 눌렀을 경우
            case showClubDetail(Club)
            case pushToLogin
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
            case .onAppear:
                return .concatenate([
                    .send(.getClubsList),
                    .send(.getClubDivisions)
                ])
            case .applyFiltersAndSort:
                var clubs = state.originalClubs
                
                if !state.selectedCategories.isEmpty {
                    let selectedNames = Set(state.selectedCategories.map { $0.code })
                    let filtered = clubs?.clubs.filter { selectedNames.contains($0.division) }
                    clubs?.clubs = filtered ?? []
                }
                
                switch state.sortType {
                case .deadline:
                    clubs?.clubs.sort {
                        parseDate($0.recruitEndDate ?? "") ?? .distantFuture <
                            parseDate($1.recruitEndDate ?? "") ?? .distantFuture
                    }
                case .alphabetical:
                    clubs?.clubs.sort { $0.name < $1.name }
                }
                
                state.filteredClubs?.clubs = clubs?.clubs ?? []
                return .none
            case .changeSortBy(let by):
                state.sortType = by
                return .send(.applyFiltersAndSort)
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
                    state.originalClubs = clubs
                    state.filteredClubs = clubs
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
            case .subscribeToClub(let id, let isSubscribed):
                return .run { send in
                    do {
                        let response = isSubscribed ?  try await kuringLink.unsubscribeToClub(id) : try await kuringLink.subscribeToClub(id)
                        await send(.subscribeToClubResponse(.success(response), id))
                    } catch {
                        await send(.subscribeToClubResponse(.failure(.error(error.localizedDescription)), id))
                    }
                }
            case .subscribeToClubResponse(let result, let id):
                switch result {
                case .success:
                    if let clubs = state.originalClubs?.clubs, let index = clubs.firstIndex(where: { $0.id == id }) {
                        state.originalClubs?.clubs[index].subscriberCount = clubs[index].subscriberCount + (clubs[index].isSubscribed ? -1 : 1)
                        state.originalClubs?.clubs[index].isSubscribed.toggle()
                    }
                    if let clubs = state.filteredClubs?.clubs, let index = clubs.firstIndex(where: { $0.id == id }) {
                        state.filteredClubs?.clubs[index].subscriberCount = clubs[index].subscriberCount + (clubs[index].isSubscribed ? -1 : 1)
                        state.filteredClubs?.clubs[index].isSubscribed.toggle()
                    }
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
            case .binding(\.selectedClubType):
                let clubs = state.originalClubs?.clubs
                guard state.selectedClubType != .all else {
                    state.filteredClubs?.clubs = clubs ?? []
                    return .none
                }
                
                let filtered = clubs?.filter { ClubsType(rawValue: $0.category) == state.selectedClubType }
                state.filteredClubs?.clubs = filtered ?? []
                return .none
            case .binding:
                return .none
            default:
                return .none
            }
        }
    }

    private func parseDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        return formatter.date(from: string)
    }
    
    public init() { }
}

