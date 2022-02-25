//
//  Bundle.Kuring.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/02/25.
//

import Foundation

extension Bundle {
    static var appVersion: String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        let version = (appVersion as! String)
        
        return version
    }
}
