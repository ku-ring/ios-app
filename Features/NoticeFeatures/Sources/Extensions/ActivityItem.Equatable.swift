//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import ActivityUI

extension ActivityItem: Equatable {
    public static func == (lhs: ActivityUI.ActivityItem, rhs: ActivityUI.ActivityItem) -> Bool {
        (lhs.items as? [String]) == (rhs.items as? [String])
        && lhs.activities == rhs.activities
        && lhs.excludedTypes == rhs.excludedTypes
    }
}
