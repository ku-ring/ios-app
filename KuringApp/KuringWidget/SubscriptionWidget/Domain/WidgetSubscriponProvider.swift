//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import Dependencies

struct WidgetSubscriponProvider {
    @Dependency(\.kuringLink) var kuringLink
    @Dependency(\.subscriptions) var subscriptions
    
    private let subscriontionRepository = SubscriontionRepository()
    
    /// 위젯 구독 선택에 따른 상태 변경
    func selection(noticeProvider: NoticeProvider) async {
        var snapshot = DataStorageManager.shared.subscriptions
        
        if snapshot.contains(where: { $0 == noticeProvider }) {
            // 기존에 구독했던 경우 > 삭제
            snapshot.remove(noticeProvider)
        } else {
            // 구독하지 않았던 경우 > 등록
            snapshot.insert(noticeProvider)
        }
        
        // 서버 데이터 통신
        let result = await subscriontionRepository.updateUnivSubscription(
            selections: snapshot
        )
        
        // 로컬 데이터 갱신
        switch result {
        case true:
            subscriptions.update(snapshot)
        case false:
            break
        }
    }
    
}
