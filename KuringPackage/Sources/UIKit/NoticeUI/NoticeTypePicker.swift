//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ComposableArchitecture

public struct NoticeCategoryPicker: View {
    @Binding var selection: NoticeProvider

    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(NoticeType.allCases, id: \.self) { category in
                        Button {
                            selection = category.provider
                        } label: {
                            NoticeTypeColumn(
                                noticeType: category,
                                selectedID: selection.category.id
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.leading, 10)
                .onChange(of: selection) { value in
                    withAnimation {
                        proxy.scrollTo(value.category.id, anchor: .center)
                    }
                }
            }
        }
        .frame(height: 48)
    }
}
