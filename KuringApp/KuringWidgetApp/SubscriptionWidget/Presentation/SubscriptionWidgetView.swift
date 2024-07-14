//
//  SubscriptionWidgetView.swift
//  KuringWidgetExtension
//
//  Created by Geon Woo lee on 2/9/24.
//

import SwiftUI
import ColorSet
import Dependencies
import Caches

struct SubscriptionWidgetView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    private let entry: SubscriptionWidgetProvider.Entry
    
    init(entry: SubscriptionWidgetProvider.Entry) {
        self.entry = entry
    }
    
    /// 칼럼 수
    private let columns: [GridItem] = [.init(), .init(), .init(), .init()]
    
    
    var body: some View {
        VStack {
            HStack {
                Text("🔔 구독중인 공지 카테고리")
                    .font(.system(size: 15, weight: .semibold))
                
                Spacer()
            }
            .padding(.top, 24)
            .padding(.bottom, 10)
            
            LazyVGrid(columns: columns) {
                ForEach(entry.noticeTypes, id: \.self) { noticeProvider in
                    Button(intent: SubscriptionWidgetAppIntent(selection: noticeProvider.korName)) {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                Color.green,
                                lineWidth: 1
                            )
                            .frame(height: 32)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        entry.subscriptions.contains(noticeProvider)
                                        ? Color.green
                                        : colorScheme == .light
                                        ? .white
                                        : .black
                                    )
                            }
                            .overlay(
                                Text(noticeProvider.korName)
                                    .foregroundColor(Color.green)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 10)
    }
    
    func d() {
//        Bookmarks.
        
    }
}
