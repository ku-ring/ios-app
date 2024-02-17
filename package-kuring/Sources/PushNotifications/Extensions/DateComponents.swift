//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

extension DateComponents {
    static var notificationDate: Self {
        var date = Self()
        let currentWeekday = Calendar.current.component(.weekday, from: Date())
        // weekday 1 ~ 7 == 월 ~ 일
        date.weekday = currentWeekday == 1
        ? 7
        : currentWeekday - 1
        date.hour = 12
        date.minute = 0
        return date
    }
}
