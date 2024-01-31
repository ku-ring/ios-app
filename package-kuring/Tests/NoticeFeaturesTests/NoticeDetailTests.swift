//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import XCTest
import Models
import Caches
import ComposableArchitecture
@testable import NoticeFeatures

// TODO: associatedType 으로 TestStore 자동 생성하게
@MainActor
final class NoticeDetailTests: XCTestCase {
    func test_bookmarkButtonTapped() async throws {
        let store = TestStore(
            initialState: NoticeDetailFeature.State(notice: Notice.random),
            reducer: { NoticeDetailFeature() },
            withDependencies: { $0.bookmarks = Bookmarks.default }
        )
        let isNoticeBookmarked = store.state.isBookmarked
        await store.send(.bookmarkButtonTapped) {
            $0.isBookmarked = !isNoticeBookmarked
        }

        await store.receive(.delegate(.bookmarkUpdated(notice, !isNoticeBookmarked)))
    }
}
