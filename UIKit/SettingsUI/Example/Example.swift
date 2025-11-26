//
//  Example.swift
//  SettingsUI
//
//  Created by Jung Hwan Park on 11/26/25.
//

import SwiftUI
import SettingsUI
import SettingsFeatures

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            SettingsApp(store: .init(initialState: SettingsAppFeature.State(), reducer: {
                SettingsAppFeature()
            }))
        }
    }
}
