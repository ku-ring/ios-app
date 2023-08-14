//
//  AppDelegate.swift
//  App
//
//  Created by Hamlit Jason on 2023/08/05.
//  Copyright © 2023 org.kuring. All rights reserved.
//

import UIKit
import Firebase
import CoreKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}
