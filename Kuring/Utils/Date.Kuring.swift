//
//  Date.Kuring.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import Foundation

extension Date {
    var toAbbreviateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
