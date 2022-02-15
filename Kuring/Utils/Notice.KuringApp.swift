//
//  Notice.KuringApp.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2021/12/10.
//

import KuringSDK

extension Notice {
    static let EMPTY = Notice(
        articleID: "",
        subject: "",
        category: .학사,
        urlString: "",
        postedAt: 0,
        tags: [],
        isNew: false,
        isRead: false,
        isSubscribed: false
    )
}


