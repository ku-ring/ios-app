//
//  Date+.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/26/25.
//

import Foundation

public extension Date {
    /// 이 달의 첫째 날
    var startDateOfMonth: Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) else {
            return Date()
        }
        return date
    }

    /// 이 달의 마지막 날
    var endDateOfMonth: Date {
        guard let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startDateOfMonth) else {
            return Date()
        }
        return date
    }
    
    /// `self`가 `otherDate`보다 3년 이상 지남
    /// 예) `self` = 2025-01-01, `otherDate` = 2021-12-31 → `true`
    func isThreeYearsOrMoreSince(_ otherDate: Date) -> Bool {
        guard let threeYearsAfter = Calendar.current.date(byAdding: .year, value: 3, to: otherDate) else {
            return false
        }
        return self >= threeYearsAfter
    }
    
    /// `self`가 `otherDate`보다 3년 이상 이전(과거)인지 확인
    /// 예)  `self` = 2025-01-01, `otherDate` = 2028-01-02 → `true`
    func isThreeYearsOrMoreBefore(_ otherDate: Date) -> Bool {
        guard let threeYearsBefore = Calendar.current.date(byAdding: .year, value: -3, to: otherDate) else {
            return false
        }
        return self <= threeYearsBefore
    }
    
    /// 두개의 날짜가 같은 주에 속하는지
    func isInDifferentWeek(from otherDate: Date) -> Bool {
        let calendar = Calendar.current
        let selfWeek = calendar.component(.weekOfYear, from: self)
        let otherWeek = calendar.component(.weekOfYear, from: otherDate)
        
        let selfYear = calendar.component(.yearForWeekOfYear, from: self)
        let otherYear = calendar.component(.yearForWeekOfYear, from: otherDate)
        
        return selfWeek != otherWeek || selfYear != otherYear
    }
}
