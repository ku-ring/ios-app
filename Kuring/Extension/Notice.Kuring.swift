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
            case .original(let articleID): return "\(StringSet.URL.konkuk)/do/MessageBoard/ArticleRead.do?id=\(articleID)"
            case .library(let articleID): return "\(StringSet.URL.konkukLibrary)/#/bbs/notice/\(articleID)"
            default: return ""
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
