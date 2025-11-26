//
//  Example.swift
//  NoticeUI
//
//  Created by Jung Hwan Park on 11/26/25.
//

import SwiftUI
import NoticeUI
import NoticeFeatures

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NoticeApp(store: .init(initialState: NoticeAppFeature.State(noticeList: NoticeListFeature.State()), reducer: {
                NoticeAppFeature()._printChanges()
            }))
        }
    }
}
