//
//  BaseURL.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2021/12/01.
//

import KuringSDK
import UIKit

extension Notice {
    enum NoticeURL {
        case original(_ articleID: String)
        case library(_ articleID: String)
        case major(_ articleID: String)
        
        var urlString: String {
            switch self {
            case .original(let articleID): return "https://www.konkuk.ac.kr/do/MessageBoard/ArticleRead.do?id=\(articleID)"
            case .library(let articleID): return "https://library.konkuk.ac.kr/#/bbs/notice/\(articleID)"
            case .major(let _): return ""
            }
        }
    }
    
    var urlString: String {
        switch category {
        case .도서관 : return NoticeURL.library(articleID).urlString
        default: return NoticeURL.original(articleID).urlString
        }
    }
}
