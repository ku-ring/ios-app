//
//  NoticeType.swift
//
//
//  Created by 🏝️ GeonWoo Lee on 9/30/23.
//

import Foundation

public enum NoticeType: Int, Hashable, CaseIterable, Identifiable {
    case 학과, 학사, 장학, 도서관, 취창업, 국제, 학생, 산학, 일반
    
    public var id: Self { self }
    
    /// v1 `normalCase`에 해당합니다
    public static var univCases: [NoticeType] {
        self.allCases.filter { $0 != .학과 }
    }
    
    public static func from(_ string: String) -> NoticeType {
        switch string {
            case "department": return .학과
            case "bachelor": return .학사
            case "scholarship": return .장학
            case "employment": return .취창업
            case "national": return .국제
            case "student": return .학생
            case "industry_university": return .산학
            case "normal": return .일반
            case "library": return .도서관
            default: return .일반
        }
    }
    
    public var koreanValue: String {
        switch self {
            case .학과: return "학과"
            case .학사: return "학사"
            case .장학: return "장학"
            case .취창업: return "취창업"
            case .국제: return "국제"
            case .학생: return "학생"
            case .산학: return "산학"
            case .일반: return "일반"
            case .도서관: return "도서관"
        }
    }
    
    public var stringValue: String {
        switch self {
            case .학과: return "department"
            case .학사: return "bachelor"
            case .장학: return "scholarship"
            case .취창업: return "employment"
            case .국제: return "national"
            case .학생: return "student"
            case .산학: return "industry_university"
            case .일반: return "normal"
            case .도서관: return "library"
        }
    }
    
    public var shortStringValue: String {
        switch self {
            case .학과: return "dep"
            case .학사: return "bch"
            case .장학: return "sch"
            case .취창업: return "emp"
            case .국제: return "nat"
            case .학생: return "stu"
            case .산학: return "ind"
            case .일반: return "nor"
            case .도서관: return "lib"
        }
    }
}

