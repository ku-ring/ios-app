//
//  NoticeListFeatureTests.swift
//
//
//  Created by Jaesung Lee on 2023/09/13.
//

import Model
import XCTest
import KuringLink
import ComposableArchitecture
@testable import NoticeListFeature

@MainActor
final class NoticeListFeatureTests: XCTestCase {
    func testExample() async throws {
        let store = TestStore(
            initialState: NoticeListFeature.State(),
            reducer: { NoticeListFeature() },
            withDependencies: { $0.kuringLink = KuringLink.testValue }
        )
        
        await store.send(.onAppear)
        
        XCTExpectFailure()
        
        await store.receive(/NoticeListFeature.Action.noticesResponse, timeout: .seconds(2)) { state in
            state.notices = []
        }
        
    }
}

