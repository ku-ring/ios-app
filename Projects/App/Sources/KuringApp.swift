//
//  KuringApp.swift
//  App
//
//  Created by Hamlit Jason on 2023/08/05.
//  Copyright © 2023 org.kuring. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

@main
struct KuringApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup(id: "kuring") {
            ContentView()
        }
    }
}
