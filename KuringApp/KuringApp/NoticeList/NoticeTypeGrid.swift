//
//  NoticeTypeGrid.swift
//  KuringApp
//
//  Created by 이재성 on 11/24/23.
//

import Model
import SwiftUI
import ComposableArchitecture

struct NoticeTypeGrid: View {
    let store: StoreOf<NoticeListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0.currentNoticeType }) { viewStore in
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(NoticeType.allCases, id: \.self) { noticeType in
                            NoticeTypeColumn(
                                noticeType: noticeType,
                                selectedID: viewStore.id
                            )
                            .onTapGesture {
                                viewStore.send(.noticeTypeSegmentTapped(noticeType))
                                withAnimation {
                                    proxy.scrollTo(noticeType, anchor: .center)
                                }
                            }
                        }
                    }
                    .padding(.leading, 10)
                }
            }
        }
    }
}
