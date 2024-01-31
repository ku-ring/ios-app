//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import DepartmentFeatures
import SubscriptionFeatures
import ComposableArchitecture

@Reducer
public struct NoticeAppFeature {
    @ObservableState
    public struct State: Equatable {
        // MARK: 네비게이션

        /// 루트
        public var noticeList = NoticeListFeature.State()
        /// 스택 네비게이션
        public var path = StackState<Path.State>()
        /// 트리 네비게이션 - ``SubscriptionAppFeature``
        @Presents public var changeSubscription: SubscriptionAppFeature.State?

        public init(
            noticeList: NoticeListFeature.State = NoticeListFeature.State(),
            path: StackState<Path.State> = StackState<Path.State>(),
            changeSubscription: SubscriptionAppFeature.State? = nil
        ) {
            self.noticeList = noticeList
            self.path = path
            self.changeSubscription = changeSubscription
            
            @Dependency(\.bookmarks) var bookmarks
            do {
                self.noticeList.bookmarkIDs = Set(try bookmarks().map(\.id))
            } catch {
                print("북마크 가져오기를 실패했습니다: \(error.localizedDescription)")
            }
        }
    }

    public enum Action {
        /// 루트(``NoticeListFeature``) 액션
        case noticeList(NoticeListFeature.Action)

        /// 스택 네비게이션 액션 (``NoticeAppFeature/Path``)
        case path(StackAction<Path.State, Path.Action>)

        /// 구독 변경 버튼을 탭한 경우
        case changeSubscriptionButtonTapped

        /// ``SubscriptionAppFeature`` 의 Presentation 액션
        case changeSubscription(PresentationAction<SubscriptionAppFeature.Action>)
    }

    @Dependency(\.bookmarks) var bookmarks
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.noticeList, action: \.noticeList) {
            NoticeListFeature()
        }

        Reduce { state, action in
            switch action {
            case let .path(.element(id: _, action: .detail(.delegate(action)))):
                switch action {
                case let .bookmarkUpdated(notice, isBookmarked):
                    do {
                        if isBookmarked {
                            state.noticeList.bookmarkIDs.remove(notice.id)
                            try bookmarks.remove(notice.id)
                        } else {
                            state.noticeList.bookmarkIDs.insert(notice.id)
                            try bookmarks.add(notice)
                        }
                    } catch {
                        print("북마크 업데이트에 실패했습니다: \(error.localizedDescription)")
                    }
                    return .none
                }

            case let .noticeList(.delegate(delegate)):
                switch delegate {
                case .editDepartment:
                    state.path.removeAll()
                    state.path.append(
                        Path.State.departmentEditor(
                            // TODO: init parameter 수정 (현재는 테스트용)
                            DepartmentEditorFeature.State(
                                myDepartments: IdentifiedArray(uniqueElements: NoticeProvider.departments),
                                results: IdentifiedArray(uniqueElements: NoticeProvider.departments)
                            )
                        )
                    )
                    return .none
                }

            case .changeSubscription(.presented(.subscriptionView(.subscriptionResponse))):
                /// ``SubscriptionAppFeature`` 액션
                state.changeSubscription = nil
                return .none

            case .changeSubscriptionButtonTapped:
                state.changeSubscription = SubscriptionAppFeature.State()
                return .none

            case .path, .noticeList, .changeSubscription:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
        .ifLet(\.$changeSubscription, action: \.changeSubscription) {
            SubscriptionAppFeature()
        }
    }

    public init() { }
}
