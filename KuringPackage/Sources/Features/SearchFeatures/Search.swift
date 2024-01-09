import Models
import KuringLink
import ComposableArchitecture

@Reducer
public struct SearchFeature {
    @ObservableState
    public struct State: Equatable {
        @Presents public var staffDetail: StaffDetailFeature.State?
        
        public var recents: [String] = []
        
        public var resultNotices: [Notice]? = nil
        public var resultStaffs: [Staff]? = nil
        
        public var searchInfo: SearchInfo = SearchInfo()
        public var focus: Field? = .search
        
        public struct SearchInfo: Equatable {
            public var text: String = ""
            public var searchType: SearchType = .notice
            public var searchPhase: SearchPhase = .before
            
            public enum SearchType: String {
                case notice
                case staff
            }
            
            public enum SearchPhase {
                /// 검색 시작 전 (API 요청 전 상태)
                case before
                /// 검색 중 (API 응답을 기다리는 상태)
                case searching
                /// 검색 완료 (결과가 있는 상태)
                case complete
                /// 검색 실패
                case failure
            }
            
            public init(
                text: String = "",
                searchType: SearchType = .notice,
                searchPhase: SearchPhase = .before
            ) {
                self.text = text
                self.searchType = searchType
                self.searchPhase = searchPhase
            }
        }
        
        public enum Field {
            case search
        }
        
        public init(
            staffDetail: StaffDetailFeature.State? = nil,
            recents: [String] = [],
            resultNotices: [Notice]? = nil,
            resultStaffs: [Staff]? = nil, 
            searchInfo: SearchInfo = .init(),
            focus: Field? = .search
        ) {
            self.staffDetail = staffDetail
            self.recents = recents
            self.resultNotices = resultNotices
            self.resultStaffs = resultStaffs
            self.searchInfo = searchInfo
            self.focus = focus
        }
    }
    
    public enum Action: BindableAction {
        /// 트리 네비게이션 - ``StaffDetailFeature`` 액션
        case staffDetail(PresentationAction<StaffDetailFeature.Action>)
        /// 세그먼트에서 검색 타입 선택
        case selectSearchType(State.SearchInfo.SearchType)
        /// 최근 검색어 전체 삭제
        case deleteAllRecentsButtonTapped
        /// 검색어 제거
        case clearKeywordButtonTapped
        /// 검색
        case search
        /// 검색 결과
        case searchResponse(Result<SearchResult, SearchError>)
        /// 최근 검색어 선택. associated value 는 최근 검색어.
        case recentSearchKeywordTapped(String)
        /// ``StaffRow`` 선택
        case staffRowSelected(Staff)
        
        case binding(BindingAction<State>)
        
        public enum SearchResult {
            case notices([Notice])
            case staffs([Staff])
        }
    }
    
    public enum SearchError: Error {
        case notice(Error)
        case staff(Error)
    }
    
    @Dependency(\.kuringLink) var kuringLink
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .selectSearchType(searchType):
                switch searchType {
                case .notice:
                    state.searchInfo = SearchFeature.State.SearchInfo(searchType: .notice)
                case .staff:
                    state.searchInfo = SearchFeature.State.SearchInfo(searchType: .staff)
                }
                return .none
                
            case .deleteAllRecentsButtonTapped:
                state.recents.removeAll()
                return .none
                
            case .clearKeywordButtonTapped:
                state.searchInfo.text = ""
                return .none
            
            case .search:
                guard !state.searchInfo.text.isEmpty else { return .none }
                
                state.focus = nil
                
                // 최근 검색어 추가
                if !state.recents.contains(state.searchInfo.text) { // 중복체크
                    state.recents.append(state.searchInfo.text)
                }
                
                state.searchInfo.searchPhase = .searching
                switch state.searchInfo.searchType {
                case .notice:
                    return .run { [keyword = state.searchInfo.text] send in
                        let notices = try await kuringLink.searchNotices(keyword)
                        await send(.searchResponse(.success(.notices(notices))))
                    } catch: { error, send in
                        await send(.searchResponse(.failure(SearchError.notice(error))))
                    }
                case .staff:
                    return .run { [keyword = state.searchInfo.text] send in
                        let staffs = try await kuringLink.searchStaffs(keyword)
                        await send(.searchResponse(.success(.staffs(staffs))))
                    } catch: { error, send in
                        await send(.searchResponse(.failure(SearchError.staff(error))))
                    }
                }
                
            case let .recentSearchKeywordTapped(keyword):
                state.searchInfo.text = keyword
                return .send(.search)
                
            case let .searchResponse(.success(results)):
                switch results {
                case let .notices(values):
                    state.resultNotices = values
                    
                case let .staffs(values):
                    state.resultStaffs = values
                }
                state.searchInfo.searchPhase = .complete
                return .none
                
            case let .searchResponse(.failure(searchError)):
                switch searchError {
                case let .notice(error):
                    print(error.localizedDescription)
                    state.resultNotices = nil
                    
                case let .staff(error):
                    print(error.localizedDescription)
                    state.resultStaffs = nil
                }
                state.searchInfo.searchPhase = .failure
                return .none
                
            case let .staffRowSelected(staff):
                state.staffDetail = StaffDetailFeature.State(staff: staff)
                return .none
                
            case .staffDetail(.dismiss):
                state.staffDetail = nil
                return .none
                
            case .staffDetail:
                return .none
            }
        }
        .ifLet(\.$staffDetail, action: /Action.staffDetail) {
            StaffDetailFeature()
        }
    }
    
    public init() { }
}

