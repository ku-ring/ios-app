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
        .configurationDisplayName("구독-ku")
        .description("구독하세요~ ku-ku")
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
    }
}
