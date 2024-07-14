//
//  SubscriptionWidgetAppIntent.swift
//  KuringWidgetExtension
//
//  Created by Geon Woo lee on 2/9/24.
//

import AppIntents
import WidgetKit

struct SubscriptionWidgetAppIntent: AppIntent {

    static var title: LocalizedStringResource = "구독 위젯"
    static var description = IntentDescription("쿠링 구독 대화형 위젯")

    /// 선택한 구독 카테고리
    @Parameter(title: "selection")
    var selection: String

    init() {}

    init(selection: String) {
        self.selection = selection
    }
    
    func perform() async throws -> some IntentResult {
        
        print("☁️ perform")
//        /// 이미 구독중인 공지 리스트
//        let selectedNoticeTypes: [NoticeType] = NoticeType.allCases
//            .filter { $0.isSubscribed }
//        
//        /// 구독중인 공지 리스트에서 새로운 공지가 들어왔을 때 확인
//        let isContains: Bool = selectedNoticeTypes.contains {
//            $0.koreanValue == selection
//        }
//        
//        var categories = selectedNoticeTypes.compactMap { $0.stringValue }
//        
//        if isContains {
//            categories.removeAll { $0 == selection }
//        } else {
//            categories.append(selection)
//        }
//        
////        print("추가 선택 \(selection)")
////        print("이미 선택한 공지 \(categories)")
//        
//        Kuring.updateSubscription(type: .univ, categories: categories) { _ in
//            WidgetCenter.shared.reloadTimelines(ofKind: SubscriptionWidget.kind)
//        }

        return .result()
    }
}
