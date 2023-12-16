import Foundation

public enum NoticeType: String, Hashable, CaseIterable, Identifiable {
    case 학과, 학사, 장학, 도서관, 취창업, 국제, 학생, 산학, 일반
    
    public var id: Self { self }
    
    public var provider: NoticeProvider {
        switch self {
        case .학과:
            return NoticeProvider.departments.first ?? NoticeProvider.emptyDepartment
        case .학사:
            return .학사
        case .장학:
            return .장학
        case .도서관:
            return .도서관
        case .취창업:
            return .취창업
        case .국제:
            return .국제
        case .학생:
            return .학생
        case .산학:
            return .산학
        case .일반:
            return .일반
        }
    }
}

public struct NoticeProvider: Identifiable, Equatable, Hashable {
    public var id: String { self.hostPrefix }
    
    public let name: String
    public let hostPrefix: String
    public let korName: String
    public var category: NoticeType
    
    public init(name: String, hostPrefix: String, korName: String, category: NoticeType) {
        self.name = name
        self.hostPrefix = hostPrefix
        self.korName = korName
        self.category = category
    }
}

extension NoticeProvider {
    public static let emptyDepartment = NoticeProvider(
        name: "",
        hostPrefix: "",
        korName: "",
        category: .학과
    )
    
    public static let 학사 = NoticeProvider(
        name: "bachelor",
        hostPrefix: "bch",
        korName: "학사",
        category: .학사
    )
    
    public static let 취창업 = NoticeProvider(
        name: "employment",
        hostPrefix: "emp",
        korName: "취창업",
        category: .취창업
    )
    
    public static let 도서관 = NoticeProvider(
        name: "library",
        hostPrefix: "lib",
        korName: "도서관",
        category: .도서관
    )
    
    public static let 학생 = NoticeProvider(
        name: "student",
        hostPrefix: "stu",
        korName: "학생",
        category: .학생
    )
    
    public static let 국제 = NoticeProvider(
        name: "national",
        hostPrefix: "nat",
        korName: "국제",
        category: .국제
    )
    
    public static let 장학 = NoticeProvider(
        name: "scholarship",
        hostPrefix: "sch",
        korName: "장학",
        category: .장학
    )
    
    public static let 산학 = NoticeProvider(
        name: "industry_university",
        hostPrefix: "ind",
        korName: "산학",
        category: .산학
    )
    
    public static let 일반 = NoticeProvider(
        name: "normal",
        hostPrefix: "nor",
        korName: "일반",
        category: .일반
    )
    
    public static let univNoticeTypes: [NoticeProvider] = [
        .학사, .취창업, .도서관, .학생, .국제, .장학, .산학, .일반
    ]
}

/// Mock 데이터
extension NoticeProvider {
    public static let departments: [NoticeProvider] = [
        NoticeProvider(
            name: "education",
            hostPrefix: "edu",
            korName: "교직과",
            category: .학과
        ),
        NoticeProvider(
            name: "physical_education",
            hostPrefix: "kupe",
            korName: "체육교육과",
            category: .학과
        ),
        NoticeProvider(
            name: "computer_science",
            hostPrefix: "cse",
            korName: "컴퓨터공학부",
            category: .학과
        ),
    ]
}


