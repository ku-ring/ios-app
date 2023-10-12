//
//  NoticeProvider.swift
//  KuringApp
//
//  Created by 이재성 on 10/12/23.
//

import Foundation

struct NoticeProvider: Identifiable, Equatable {
    var id: String { self.hostPrefix }
    
    let name: String
    let hostPrefix: String
    let korName: String
}

extension NoticeProvider {
    static let univNoticeTypes: [NoticeProvider] = [
        NoticeProvider(
            name: "bachelor",
            hostPrefix: "bch",
            korName: "학사"
        ),
        NoticeProvider(
            name: "employment",
            hostPrefix: "emp",
            korName: "취창업"
        ),
        NoticeProvider(
            name: "library",
            hostPrefix: "lib",
            korName: "도서관"
        ),
        NoticeProvider(
            name: "student",
            hostPrefix: "stu",
            korName: "학생"
        ),
        NoticeProvider(
            name: "national",
            hostPrefix: "nat",
            korName: "국제"
        ),
        NoticeProvider(
            name: "scholarship",
            hostPrefix: "sch",
            korName: "장학"
        ),
        NoticeProvider(
            name: "industry_university",
            hostPrefix: "ind",
            korName: "산학"
        ),
        NoticeProvider(
            name: "normal",
            hostPrefix: "nor",
            korName: "일반"
        ),
    ]
}

/// Mock 데이터
extension NoticeProvider {
    static let departments: [NoticeProvider] = [
        NoticeProvider(
            name: "education",
            hostPrefix: "edu",
            korName: "교직과"
        ),
        NoticeProvider(
            name: "physical_education",
            hostPrefix: "kupe",
            korName: "체육교육과"
        ),
        NoticeProvider(
            name: "computer_science",
            hostPrefix: "cse",
            korName: "컴퓨터공학부"
        ),
    ]
}
