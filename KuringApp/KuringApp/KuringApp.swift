//
//  KuringAppApp.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/13.
//

import SwiftUI
import ComposableArchitecture

@main
struct KuringApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            NavigationStack {
                SearchView(
                    store: Store(
                        initialState: SearchFeature.State(recents: ["방학", "운송수단", "운임표"]),
                        reducer: { SearchFeature() }
                    )
                )
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Search View")
            }
        }
    }
}
