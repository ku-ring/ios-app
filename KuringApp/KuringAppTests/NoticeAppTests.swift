//
//  NoticeAppTests.swift
//  KuringAppTests
//
//  Created by 이재성 on 10/10/23.
//

import XCTest
import ComposableArchitecture
@testable import KuringApp

@MainActor
final class NoticeAppTests: XCTestCase {
    /// 푸시 액션 테스트: 검색 버튼 눌렀을 때
    func test_editDepartment() async {
        let store = TestStore(
            initialState: NoticeAppFeature.State(
                noticeList: NoticeListFeature.State()
            ),
            reducer: { NoticeAppFeature() }
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
}
