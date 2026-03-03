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
        public var selectedClubType: ClubsType = .all
        /// 동아리 목록 (원본 데이터)
        public var originalClubs: ClubsResult?
        /// 동아리 목록 (화면에 보여줄 최종 데이터)
        public var filteredClubs: ClubsResult?
        /// 동아리 소속 목록
        public var clubDivisions: ClubDivisions = .init(divisions: [
            .init(code: "CENTRAL", koreanName: "중앙"),
            .init(code: "LIBERAL_ARTS", koreanName: "문과대학"),
            .init(code: "SCIENCE", koreanName: "이과대학"),
            .init(code: "ARCHITECTURE", koreanName: "건축대학"),
            .init(code: "ENGINEERING", koreanName: "공과대학"),
            .init(code: "SOCIAL_SCIENCES", koreanName: "사회과학대학"),
            .init(code: "BUSINESS", koreanName: "경영대학"),
            .init(code: "REAL_ESTATE", koreanName: "부동산과학원"),
            .init(code: "KU_CONVERGENCE", koreanName: "KU융합과학기술원"),
            .init(code: "SANGHUH_LIFE_SCIENCE", koreanName: "상허생명과학대학"),
            .init(code: "VETERINARY", koreanName: "수의과대학"),
            .init(code: "ART_DESIGN", koreanName: "예술디자인대학"),
            .init(code: "EDUCATION", koreanName: "사범대학"),
            .init(code: "SANGHUH_GENERAL", koreanName: "상허교양대학"),
            .init(code: "INTERNATIONAL", koreanName: "국제대학"),
            .init(code: "CONVERGENCE_SCI_TECH", koreanName: "융합과학기술원"),
            .init(code: "LIFE_SCIENCE", koreanName: "생명과학대학"),
            .init(code: "COMPUTER_SCIENCE", koreanName: "컴퓨터공학과"),
            .init(code: "MECHANICAL_ENGINEERING", koreanName: "기계공학과"),
            .init(code: "ETC", koreanName: "기타")
        ])
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
        case subscribeToClub(Int)
        case subscribeToClubResponse(Result<ClubBookmarkCountResponse, ClubsKuringError>, Int)
        
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
            case .applyFiltersAndSort:
                var clubs = state.originalClubs
                
                if !state.selectedCategories.isEmpty {
                    let selectedNames = Set(state.selectedCategories.map { $0.koreanName })
                    let filtered = clubs?.clubs.filter { selectedNames.contains($0.division) }
                    clubs?.clubs = filtered ?? []
                }
                
                switch state.sortType {
                case .deadline:
                    clubs?.clubs.sort {
                        parseDate($0.recruitEndDate) ?? .distantFuture <
                            parseDate($1.recruitEndDate) ?? .distantFuture
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
            case .subscribeToClub(let id):
                return .run { send in
                    do {
                        let response = try await kuringLink.subscribeToClub(id)
                        await send(.subscribeToClubResponse(.success(response), id))
                    } catch {
                        await send(.subscribeToClubResponse(.failure(.error(error.localizedDescription)), id))
                    }
                }
            case .subscribeToClubResponse(_, let id):
                if let index = state.originalClubs?.clubs.firstIndex(where: { $0.id == id }) {
                    state.originalClubs?.clubs[index].isSubscribed.toggle()
                }
                
                return .send(.applyFiltersAndSort)
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

