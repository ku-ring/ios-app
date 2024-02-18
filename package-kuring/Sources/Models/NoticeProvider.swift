//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

/// 공지 제공자 카테고리
public enum NoticeType: String, Hashable, CaseIterable, Identifiable, Equatable {
    case 학과, 대학, 세팅하지않음

    public var id: Self { self }

    // TODO: defaultProvider
    /// 카테고리 별 첫번째(기본) 제공자
    public var provider: NoticeProvider {
        switch self {
        case .학과:
            return NoticeProvider.departments.first ?? NoticeProvider.emptyDepartment
        case .대학:
            return NoticeProvider.학사
        }
    }
}

/// 공지 제공자.
/// 일반, 학사, 장학과 같은 대학 공지 카테고리, 전기전자공학부, 컴퓨터공학부, 산업디자인학과와 같은 학과들처럼 공지를 제공하는 주체.
/// - Note: ``NoticeProvider/category`` 프로퍼티로 상위 카테고리를 관리합니다.
public struct NoticeProvider: Identifiable, Equatable, Hashable, Decodable {
    /// ``hostPrefix`` 를 식별자로 사용합니다.
    public var id: String { hostPrefix }

    /// 공지 제공자 이름 (영문)
    /// - Note: 국문 이름은 ``korName``.
    public let name: String
    /// 공지 제공자 호스트 Prefix.
    /// - Important: ID 로 사용합니다.
    public let hostPrefix: String
    /// 공지 제공자 이름 (국문)
    public let korName: String
    /// 상위 카테고리. 예) 대학공지, 학과공지
    /// - Note: 서버값으로 부터 디코딩을 하지 않는 값이므로 직접 세팅해줘야 합니다.
    public var category: NoticeType
    
    enum CodingKeys: String, CodingKey {
        case name
        case hostPrefix
        case korName
    }

    public init(name: String, hostPrefix: String, korName: String, category: NoticeType) {
        self.name = name
        self.hostPrefix = hostPrefix
        self.korName = korName
        self.category = category
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.hostPrefix = try container.decode(String.self, forKey: .hostPrefix)
        self.korName = try container.decode(String.self, forKey: .korName)
        self.category = .세팅하지않음
    }
}

// MARK: - 대학 공지
extension NoticeProvider {
    // TODO: Swift Data 에서 가져오기
    // TODO: 순서는?
    /// 앱 실행 시 모든 학과 정보를 가져와서 여기에 저장. 그 이후로 다음 앱 실행 전까지 로컬 값만 사용합니다.
    /// 네트워크 요청 실패시 로컬에 저장된 값을 default 값으로 사용합니다.
    public static var univNoticeTypes: [NoticeProvider] = [
        .학사, .취창업, .도서관, .학생, .국제, .장학, .산학, .일반,
    ]
    
    public static var subscribedUnivNoticeTypes: [NoticeProvider] = []
    
    public static let 학사 = NoticeProvider(
        name: "bachelor",
        hostPrefix: "bch",
        korName: "학사",
        category: .대학
    )

    public static let 취창업 = NoticeProvider(
        name: "employment",
        hostPrefix: "emp",
        korName: "취창업",
        category: .대학
    )

    public static let 도서관 = NoticeProvider(
        name: "library",
        hostPrefix: "lib",
        korName: "도서관",
        category: .대학
    )

    public static let 학생 = NoticeProvider(
        name: "student",
        hostPrefix: "stu",
        korName: "학생",
        category: .대학
    )

    public static let 국제 = NoticeProvider(
        name: "national",
        hostPrefix: "nat",
        korName: "국제",
        category: .대학
    )

    public static let 장학 = NoticeProvider(
        name: "scholarship",
        hostPrefix: "sch",
        korName: "장학",
        category: .대학
    )

    public static let 산학 = NoticeProvider(
        name: "industry_university",
        hostPrefix: "ind",
        korName: "산학",
        category: .대학
    )

    public static let 일반 = NoticeProvider(
        name: "normal",
        hostPrefix: "nor",
        korName: "일반",
        category: .대학
    )
}

// MARK: - 학과 공지
extension NoticeProvider {
    // TODO: Swift Data 에서 가져오기
    /// 앱 실행 시 모든 학과 정보를 가져와서 여기에 저장. 그 이후로 다음 앱 실행 전까지 로컬 값만 사용합니다.
    /// 네트워크 요청 실패시 로컬에 저장된 값을 default 값으로 사용합니다.
    public static var departments: [NoticeProvider] = [
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
    /// 추가한 학과 (구독여부와 상관없음)
    public static var addedDepartments: [NoticeProvider]
    /// 구독한 학과
    public static var subscribedDepartments: [NoticeProvider] = []
    
    public static let emptyDepartment = NoticeProvider(
        name: "",
        hostPrefix: "",
        korName: "",
        category: .학과
    )
}
