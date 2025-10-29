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
    /// 기타
    case etc = "ETC"
    /// 학사운영/행사
    case academicOperationEvent = "ACADEMIC_OPERATION_EVENT"
    /// 등록/수강/성적
    case registrationCourseGrade = "REGISTRATION_COURSE_GRADE"
    /// 학적/학위
    case academicDegree = "ACADEMIC_DEGREE"
    
    var color: Color {
        switch self {
        case .etc:
            return Color.Kuring.etc
        case .academicOperationEvent:
            return Color.Kuring.event
        case .registrationCourseGrade:
            return Color.Kuring.registration
        case .academicDegree:
            return Color.Kuring.degree
        }
    }
}
