import XCTest
import ComposableArchitecture
@testable import Caches
@testable import Models
@testable import BookmarkFeatures

@MainActor
final class BookmarkListTests: XCTestCase {
    override func setUpWithError() throws {
        try Bookmarks.default.remove(Notice.random.id)
        try Bookmarks.default.add(Notice.random)
    }
    
    /// 북마크 리스트 가져오기
    func test_onAppear() async throws {
        let store = TestStore(
            initialState: BookmarkListFeature.State(),
            reducer: { BookmarkListFeature() },
            withDependencies: {
                $0.bookmarks = Bookmarks.default
            }
        )
        let notice = Notice.random
        
        await store.send(.onAppear) {
            $0.bookmarkedNotices = IdentifiedArray(uniqueElements: [notice])
        }
    }
    
    /// 편집 버튼 누르기
    func test_editButtonTapped() async throws {
        let store = TestStore(
            initialState: BookmarkListFeature.State(),
            reducer: { BookmarkListFeature() },
            withDependencies: {
                $0.bookmarks = Bookmarks.default
            }
        )
        
        await store.send(.editButtonTapped) {
            $0.editMode = .editing(deletable: false)
        }
    }
    
    /// 편집 버튼 누르고 선택
    /// 삭제 가능 상태인지 체크
    func test_editButtonTappedAndSelectedIDsUpdated() async throws {
        let store = TestStore(
            initialState: BookmarkListFeature.State(),
            reducer: { BookmarkListFeature() },
            withDependencies: {
                $0.bookmarks = Bookmarks.default
            }
        )
        
        store.exhaustivity = .off(showSkippedAssertions: true)
        
        await store.send(.editButtonTapped) {
            $0.editMode = .editing(deletable: false)
        }
        
        await store.send(.set(\.selectedIDs, [Notice.random.id])) {
            $0.selectedIDs = [Notice.random.id]
            $0.editMode = .editing(deletable: true)
        }
    }
    
    /// 삭제 요청
    /// 편집모드 업데이트 되는지 확인
    func test_editButtonTappedAndDeleteButtonTapped() async throws {
        let store = TestStore(
            initialState: BookmarkListFeature.State(),
            reducer: { BookmarkListFeature() },
            withDependencies: {
                $0.bookmarks = Bookmarks.default
            }
        )
        
        store.exhaustivity = .off
        
        await store.send(.editButtonTapped) {
            $0.editMode = .editing(deletable: false)
        }
        
        await store.send(.set(\.selectedIDs, [Notice.random.id])) {
            $0.selectedIDs = [Notice.random.id]
            $0.editMode = .editing(deletable: true)
        }
        
        await store.send(.deleteButtonTapped) {
            $0.bookmarkedNotices = []
            $0.editMode = .none
        }
    }
}
