//
//  AcademicEventCategory.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/24/25.
//

import ColorSet
import Foundation
import SwiftUICore

enum AcademicEventCategory: String {
    case etc = "ETC"
    
    var color: Color {
        switch self {
        case .etc:
            return Color.Kuring.etc
        }
    }
}
