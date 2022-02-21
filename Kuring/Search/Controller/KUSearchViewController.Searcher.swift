//
//  KUSearchViewController.Searcher.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK

extension KUSearchViewController: SearcherDelegate {
    
    /// 서쳐의 연결 상태가 변경될 때마다 호출되는 이벤트 입니다.
    func searcher(_ searcher: Searcher, didChangeState state: Searcher.ConnectionState) {
        // NOTE: disconnected 일 때 연결상태가 불안정하다는 시스템 메세지를 보여줘야 하나?
    }
    
    /// 서쳐에서 에러가 발생할 때 호출되는 이벤트 입니다.
    func searcher(_ searcher: Searcher, didReceiveError error: Error?) {
        Logger.debug(error?.localizedDescription ?? "")
    }
    
    /// 서쳐에서 교직원 정보(`[Staff]`)를 가져왔을 때 호출 되는 이벤트 입니다.
    func searcher(_ searcher: Searcher, didReceiveStaffList staffs: [Staff]) {
        self.staffResult = staffs
    }
    
    /// 서쳐에서 공지 정보(`[Notice]`)를 가져왔을 때 호출 되는 이벤트 입니다.
    func searcher(_ searcher: Searcher, didReceiveNoticeList notices: [Notice]) {
        self.noticeResult = notices
    }
    
    /// 서처에서 웹소켓 연결 유지를 위해 30초마다 보내는 **heart beat** 가 서버로 전송 되었을 때 호출되는 이벤트 입니다.
    func searcherDidSendHeartbeat(_ searcher: Searcher) {
        // TODO: 주기적으로 핑 보내는지 확인 필요
        Logger.debug("didSendHeartbeat")
    }
}
