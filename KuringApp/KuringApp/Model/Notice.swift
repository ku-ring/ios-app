//
//  Notice.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/04.
//

import Foundation

/**
 ```json
 // Server data
 {
     "articleId": "5b45b56",
     "postedDate": "post_date_1",
     "subject": "subject_1",
     "url": "https://www.konkuk.ac.kr/do/MessageBoard/ArticleRead.do?id=5b45b56",
     "category": "student",
     "important": true
 }
 ```
 */
struct Notice: Equatable, Identifiable, Codable {
    let articleId: String
    let important: Bool
    let subject: String
    let url: String
    let postedDate: String

    var id: String { articleId }
}
