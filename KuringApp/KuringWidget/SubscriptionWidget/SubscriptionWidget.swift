//
//  SubscriptionWidget.swift
//  Kuring
//
//  Created by Geon Woo lee on 2/8/24.
//

import SwiftUI
import WidgetKit

struct SubscriptionWidget: Widget {
    
    static let kind: String = String(describing: SubscriptionWidget.self)
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: SubscriptionWidget.kind, provider: SubscriptionWidgetProvider()) { entry in
            SubscriptionWidgetView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("쿠링")
        .description("쿠링 구독 대화형 위젯")
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
    }
}
