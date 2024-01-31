//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import XCTest
import Caches
import Models
import ComposableArchitecture
@testable import NoticeFeatures
@testable import SearchFeatures

@MainActor
final class NoticeAppTests: XCTestCase {
    override func setUpWithError() throws {
        try Bookmarks.default.remove(Notice.random.id)
        try Bookmarks.default.add(Notice.random)
    }
    
    /// 푸시 액션 테스트: 검색 버튼 눌렀을 때
    func test_editDepartment() async {
        let store = TestStore(
            initialState: NoticeAppFeature.State(
                noticeList: NoticeListFeature.State()
            ),
            reducer: { NoticeAppFeature() },
            withDependencies: { $0.bookmarks = Bookmarks.default }
        )

        // 푸시 액션: 검색 버튼 눌렀을 때
        await store.send(
            .path(
                .push(
                    id: 0,
                    state: .search(SearchFeature.State())
                )
            )
        ) {
            $0.path[id: 0] = .search(SearchFeature.State())
        }
    }
    
    // 리스트와 디테일간 북마크 싱크 테스트
    func test_bookmarkOnList_and_cancelOnDetail() async {
        let notice = Notice.random
        let store = TestStore(
            initialState: NoticeAppFeature.State(
                noticeList: NoticeListFeature.State(
                    provider: .일반,
                    noticeDictionary: [.일반: .init(notices: [notice], page: 0, hasNextList: false)]
                )
            ),
            reducer: { NoticeAppFeature() },
            withDependencies: { $0.bookmarks = Bookmarks.default }
        )
        let detailState = NoticeDetailFeature.State(
            notice: notice,
            isBookmarked: true
        )
        // 공지리스트의 북마크 리스트 초기화
        await store.send(.noticeList(.set(\.bookmarkIDs, []))) {
            $0.noticeList.bookmarkIDs = []
        }
        
        // 공지리스트에서 공지 북마크
        await store.send(.noticeList(.bookmarkTapped(notice))) {
            $0.noticeList.bookmarkIDs = [notice.id]
        }
        
        // 푸시 액션: 공지 디테일
        await store.send(
            .path(.push(id: 0, state: .detail(detailState)))
        ) {
            $0.path[id: 0] = .detail(detailState)
        }
        
        // 공지디테일에서 공지 북마크 해지
        await store.send(.path(.element(id: 0, action: .detail(.bookmarkButtonTapped)))) {
            $0.path[id: 0, case: \.detail]?.isBookmarked = false
        }
        
        // 싱크를 위한 공지디테일 Delegate 호출
        await store.receive(
            .path(
                .element(
                    id: 0, 
                    action: .detail(.delegate(.bookmarkUpdated(notice, false)))
                )
            )
        ) {
            $0.noticeList.bookmarkIDs = []
        }
    }
}
