//
//  DateFormatter+Extension.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/2/25.
//

import Foundation

extension DateFormatter {
    static let commentDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter
    }()
    
    static let serverDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return formatter
    }()
}
