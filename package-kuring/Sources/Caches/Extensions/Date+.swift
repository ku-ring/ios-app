//
//  Date+.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/26/25.
//

import Foundation

extension Date {
    /// 이 달의 첫째 날
    public var startDateOfMonth: Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) else {
            return Date()
        }
        return date
    }

    /// 이 달의 마지막 날
    public var endDateOfMonth: Date {
        guard let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startDateOfMonth) else {
            return Date()
        }
        return date
    }
}
