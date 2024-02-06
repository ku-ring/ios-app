//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import XCTest
import Models
import Caches
import ActivityUI
import ComposableArchitecture
@testable import NoticeFeatures

// TODO: associatedType 으로 TestStore 자동 생성하게
@MainActor
final class NoticeDetailTests: XCTestCase {
    /// 북마크 버튼 탭 액션을 테스트
    func test_bookmarkButtonTapped() async throws {
        let notice = Notice.random
        let store = TestStore(
            initialState: NoticeDetailFeature.State(notice: notice),
            reducer: { NoticeDetailFeature() },
            withDependencies: { $0.bookmarks = Bookmarks.default }
        )
        let isNoticeBookmarked = store.state.isBookmarked
        await store.send(.bookmarkButtonTapped) {
            $0.isBookmarked = !isNoticeBookmarked
        }

        await store.receive(.delegate(.bookmarkUpdated(notice, !isNoticeBookmarked)))
    }
    
    /// 공유하기 버튼 탭 액션을 테스트
    /// 초기값: `nil`
    /// 결과값: `notice` 가지고 `ActivityItem` 세팅
    func test_shareButtonTapped() async throws {
        let notice = Notice.random
        let store = TestStore(
            initialState: NoticeDetailFeature.State(notice: notice),
            reducer: { NoticeDetailFeature() },
            withDependencies: { $0.bookmarks = Bookmarks.default }
        )
        XCTAssertNil(store.state.shareItem)
        
        await store.send(.shareButtonTapped) {
            $0.shareItem = ActivityItem(items: notice.url)
        }
    }
}
