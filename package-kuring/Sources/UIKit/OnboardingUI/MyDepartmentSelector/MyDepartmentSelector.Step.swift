//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

extension MyDepartmentSelector {
    enum Step: Identifiable {
        case searchDepartment
        case selectDepartment
        case addedDepartment
        
        var id: Self { self }
    }
}
