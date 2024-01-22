//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import KuringLink
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
        public var provider: NoticeProvider = NoticeProvider.departments.first ?? NoticeProvider.학사

        /// 현재 공지를 가져오는 중인지 알려주는 Bool 값
        public var isLoading = false

        // TODO: 공지 데이터 저장 관련 로직은 전부 디펜던시로 옮기기
        /// 공지
        public var noticeDictionary: [NoticeProvider: NoticeInfo] = [:]

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

        public init(
            changeDepartment: DepartmentSelectorFeature.State? = nil,
            provider: NoticeProvider = NoticeProvider.departments.first ?? NoticeProvider.학사,
            isLoading: Bool = false,
            noticeDictionary: [NoticeProvider: NoticeInfo] = [:]
        ) {
            self.changeDepartment = changeDepartment
            self.provider = provider
            self.isLoading = isLoading
            self.noticeDictionary = noticeDictionary
        }
    }

    public enum Action: BindableAction {
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
        case noticesResponse(TaskResult<(NoticeProvider, [Notice])>)

        /// 북마크 버튼을 탭한 경우
        /// - Parameter notice: 북마크 액션 대상인 공지
        case bookmarkTapped(Notice)

        case loadingChanged(Bool)

        case providerChanged(NoticeProvider)

        /// ``NoticeAppFeature`` 에 전달 될 액션 종류
        public enum Delegate {
            /// 학과 편집 버튼을 선택한 경우
            case editDepartment
        }
    }

    public enum CancelID {
        case fetchNotices
    }

    @Dependency(\.bookmarks) public var bookmarks
    @Dependency(\.kuringLink) public var kuringLink

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchNotices)

            case .changeDepartmentButtonTapped:
                state.changeDepartment = DepartmentSelectorFeature.State(
                    currentDepartment: state.provider,
                    addedDepartment: IdentifiedArray(uniqueElements: NoticeProvider.departments) // TODO: Dependency
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
                                    provider.category == .학과 ? "dep" : provider.hostPrefix, // TODO: korean name 도 쓸 거 고려해서 문자열 말고 좀 더 나은걸로
                                    department,
                                    retrievalInfo.page
                                )
                                return (provider, notices)
                            }
                        )
                    )
                }
                .cancellable(id: CancelID.fetchNotices, cancelInFlight: true)

            case let .noticesResponse(.success((noticeType, notices))):
                if state.noticeDictionary[noticeType] == nil {
                    state.noticeDictionary[noticeType] = State.NoticeInfo()
                }
                guard var noticeInfo = state.noticeDictionary[noticeType] else { return .none }

                noticeInfo.hasNextList = notices.count >= noticeInfo.loadLimit
                noticeInfo.page += 1
                noticeInfo.notices += notices

                state.noticeDictionary[noticeType] = noticeInfo
                state.isLoading = false
                return .none

            case let .noticesResponse(.failure(error)):
                print(error.localizedDescription)
                state.isLoading = false
                return .none

            case let .bookmarkTapped(notice):
                do {
                    print("공지#\(notice.articleId)을 북마크 했습니다.")
                    try bookmarks.add(notice)
                } catch {
                    print("북마크 하는 중에 에러가 발생했습니다: \(error.localizedDescription)")
                }
                return .none

            case let .loadingChanged(isLoading):
                state.isLoading = isLoading
                return .none

            case let .providerChanged(provider):
                state.provider = provider
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
