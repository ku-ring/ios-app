//
//  Subscription.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/25.
//

import SwiftUI
import KuringSDK
import KuringCommons

extension NoticeType {
    var isSubscribed: Bool {
        Kuring.subscribedCategories.contains(self)
    }
}

public class NoticeTypeSubscription: ObservableObject {
    @Published var selectedNoticeTypes: [NoticeType] = NoticeType.allCases.filter { $0.isSubscribed }
    @Published var kuisNoticeTypes: [NoticeType] = NoticeType.allCases
    @Published var isUpdatable: Bool = false
    @Published var isSaved: Bool = false
    
    
    public func select(kuis: NoticeType) {
        if isSelecting(kuis) {
            selectedNoticeTypes.removeAll { $0 == kuis }
        } else {
            selectedNoticeTypes.append(kuis)
        }
        isUpdatable = true
    }
    
    public func isSelecting(_ noticeType: NoticeType) -> Bool {
        selectedNoticeTypes.contains(noticeType)
    }
    
    public func save() {
        HapticManager.shared.createImpact()
        
        let subscriptionList = selectedNoticeTypes.compactMap { $0.stringValue }
        // Remote
        Kuring.updateSubscription(categories: subscriptionList) { _ in }
        // Local
        Kuring.categoryStrings = subscriptionList
        
        isSaved = true
        isUpdatable = false
    }
    
    public func reset() {
        HapticManager.shared.createImpact()
        
        self.selectedNoticeTypes = NoticeType.allCases.filter { $0.isSubscribed }
        
        isUpdatable = false
    }
}
