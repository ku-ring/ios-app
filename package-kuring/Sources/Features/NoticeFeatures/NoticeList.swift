//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import Networks
import DepartmentFeatures
import ComposableArchitecture

@Reducer
public struct NoticeListFeature {
    @ObservableState
    public struct State: Equatable {
        // MARK: 네비게이션

        @Presents public var changeDepartment: DepartmentSelectorFeature.State?

        /// 현재 공지리스트를 제공하는 `NoticeProvider` 값
        ///
        /// - IMPORTANT: 추가한 학과가 있으면 추가한 학과의 첫번째 값이 초기값으로 세팅되고 없으면 `.학사`
        public var provider: NoticeProvider

        /// 현재 공지를 가져오는 중인지 알려주는 Bool 값. 기본값은 `false`
        public var isLoading: Bool

        // TODO: 공지 데이터 저장 관련 로직은 전부 디펜던시로 옮기기
        /// 공지
        public var noticeDictionary: [NoticeProvider: NoticeInfo]
        
        /// 북마크한 공지 ID 집합
        public var bookmarkIDs: Set<Notice.ID>

        /// 현재 `NoticeProvider` 에 대한 공지 데이터 리스트값
        public var currentNotices: [Notice] {
            noticeDictionary[provider]?.notices ?? []
        }

        // TODO: 공지 데이터 저장 관련 로직은 전부 디펜던시로 옮기기
        public struct NoticeInfo: Equatable {
            /// 공지
            public var notices: [Notice] = []
            /// 공지 페이지
            public var page: Int = 0
            /// 공지를 더 가져올 수 있는지 여부
            public var hasNextList: Bool = true
            /// 한번 요청 시 가져올 수 있는 공지 사항 개수 최댓값
            public let loadLimit = 20
        }

        /// - Important: ``bookmarkIDs`` 는 ``NoticeAppFeature/State`` 의 생성자에서 `@Dependency(\.bookmarks)`를 사용해 값 세팅
        public init(
            changeDepartment: DepartmentSelectorFeature.State? = nil,
            provider: NoticeProvider = NoticeProvider.addedDepartments.first ?? NoticeProvider.학사,
            isLoading: Bool = false,
            noticeDictionary: [NoticeProvider: NoticeInfo] = [:],
            bookmarkIDs: Set<Notice.ID> = [] // 오직 테스트만을 위한 용도
        ) {
            @Dependency(\.departments) var departments
            
            self.changeDepartment = changeDepartment
            self.provider = departments.getCurrent() ?? .학사
            self.isLoading = isLoading
            self.noticeDictionary = noticeDictionary
            self.bookmarkIDs = bookmarkIDs
        }
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)

        /// `onAppear` 이 호출된 경우
        case onAppear

        /// 학과 변경하기 버튼을 탭한 경우
        case changeDepartmentButtonTapped

        /// ``DepartmentSelectorFeature`` 의 Presentation 액션
        case changeDepartment(PresentationAction<DepartmentSelectorFeature.Action>)

        /// ``NoticeAppFeature`` 으로 액션을 전달하기 위한 델리게이트
        case delegate(Delegate)

        /// 공지를 가져오기 위한 네트워크 요청을 하는 경우
        case fetchNotices

        /// 네트워크 요청에 대한 응답을 받은 경우
        case noticesResponse(TaskResult<NoticesResult>)

        /// 북마크 버튼을 탭한 경우
        /// - Parameter notice: 북마크 액션 대상인 공지
        case bookmarkTapped(Notice)

        case loadingChanged(Bool)

        case providerChanged(NoticeProvider)

        /// ``NoticeAppFeature`` 에 전달 될 액션 종류
        public enum Delegate: Equatable {
            /// 학과 편집 버튼을 선택한 경우
            case editDepartment
            /// 북마크 업데이트 발생한 경우
            case bookmarkUpdated(Notice)
        }
        
        public struct NoticesResult: Equatable {
            let provider: NoticeProvider
            let notices: [Notice]
        }
    }

    public enum CancelID {
        case fetchNotices
    }

    /// 쿠링 서버 네트워크
    @Dependency(\.kuringLink) public var kuringLink

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
                // TODO: 이니셜라이저로
            case .onAppear:
                return .send(.fetchNotices)

            case .changeDepartmentButtonTapped:
                state.changeDepartment = DepartmentSelectorFeature.State(
                    currentDepartment: state.provider,
                    addedDepartment: IdentifiedArray(uniqueElements: NoticeProvider.addedDepartments)
                )
                return .none

            case let .changeDepartment(.presented(.delegate(delegate))):
                switch delegate {
                case .editDepartment:
                    state.changeDepartment = nil
                    return .send(.delegate(.editDepartment))
                }

            case .changeDepartment(.presented(.selectDepartment)):
                /// ``DepartmentSelectorFeature`` 액션
                guard let selectedDepartment = state.changeDepartment?.currentDepartment else {
                    return .none
                }
                state.provider = selectedDepartment
                NoticeProvider.allNamesForPicker.updateValue(
                    state.provider,
                    forKey: "학과"
                )
                return .none

            case .changeDepartment(.dismiss):
                return .send(.fetchNotices)

            case .fetchNotices:
                if state.provider == .emptyDepartment {
                    return .none
                }
                state.isLoading = true

                return .run { [provider = state.provider, noticeDictionary = state.noticeDictionary] send in
                    // TODO: 공지 데이터 저장 관련 로직은 전부 디펜던시로 옮기기
                    let retrievalInfo = noticeDictionary[provider] ?? State.NoticeInfo()

                    let department: String? = if provider.category == .학과 {
                        provider.hostPrefix
                    } else {
                        nil
                    }
                    await send(
                        .noticesResponse(
                            TaskResult {
                                let notices = try await kuringLink.fetchNotices(
                                    retrievalInfo.loadLimit,
                                    provider.category == .학과 
                                    ? "dep" // TODO: korean name 도 쓸 거 고려해서 문자열 말고 좀 더 나은걸로
                                    : provider.hostPrefix,
                                    department,
                                    retrievalInfo.page
                                )
                                return Action.NoticesResult(
                                    provider: provider,
                                    notices: notices
                                )
                            }
                        )
                    )
                }
                .cancellable(id: CancelID.fetchNotices, cancelInFlight: true)

            case let .noticesResponse(.success(noticesResult)):
                let provider = noticesResult.provider
                let notices = noticesResult.notices
                if state.noticeDictionary[provider] == nil {
                    state.noticeDictionary[provider] = State.NoticeInfo()
                }
                guard var noticeInfo = state.noticeDictionary[provider] else { return .none }

                noticeInfo.hasNextList = notices.count >= noticeInfo.loadLimit
                noticeInfo.page += 1
                noticeInfo.notices += notices

                state.noticeDictionary[provider] = noticeInfo
                state.isLoading = false
                return .none

            case let .noticesResponse(.failure(error)):
                print(error.localizedDescription)
                state.isLoading = false
                return .none

            case let .bookmarkTapped(notice):
                if state.bookmarkIDs.contains(notice.id) {
                    state.bookmarkIDs.remove(notice.id)
                } else {
                    state.bookmarkIDs.insert(notice.id)
                }
                return .send(.delegate(.bookmarkUpdated(notice)))

            case let .loadingChanged(isLoading):
                state.isLoading = isLoading
                return .none

            case let .providerChanged(provider):
                @Dependency(\.departments) var departments
                
                state.provider = provider.category == .학과
                ? departments.getCurrent() ?? NoticeProvider.emptyDepartment
                : provider
                return .send(.fetchNotices)

            case .binding, .delegate, .changeDepartment:
                return .none
            }
        }
        .ifLet(\.$changeDepartment, action: \.changeDepartment) {
            DepartmentSelectorFeature()
        }
    }

    public init() { }
}
