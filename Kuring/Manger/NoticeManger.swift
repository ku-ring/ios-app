//
//  NoticeManger.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/03/20.
//

import UIKit

class NoticeManager {
    
    /// 로컬에 저장되어 있는 noticeList 정보를 가져오기
    static var readNoticeIDs: [String] { UserDefaultManager.noticeList }
    
    /// 로컬에 저장되어 있는 noticeList 정보를 업데이트 합니다.
    static func update(id: String) {
        var notice_list = NoticeManager.readNoticeIDs
        
        if !notice_list.contains(id) {
            notice_list.append(id)
            
            UserDefaultManager.noticeList = notice_list
        }
    }
}

#if DEBUG
extension NoticeManager {
    /// 로컬에 저장되어 있는 모든 noticeList를 지웁니다.
    static func deleteAll() {
        UserDefaultManager.noticeList = []
    }
}
#endif
