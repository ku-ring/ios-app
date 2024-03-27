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
                    ForEach(
                        NoticeProvider.allNamesForPicker.compactMap({ $0.key }),
                        id: \.self
                    ) { key in
                        Button {
                            selection = NoticeProvider.allNamesForPicker[key] ?? .invalid
                        } label: {
                            NoticeTypeColumn(
                                key: key,
                                provider: NoticeProvider.allNamesForPicker[key] ?? .invalid,
                                selection: selection
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.leading, 10)
                .onChange(of: selection) { _, value in
                    withAnimation {
                        proxy.scrollTo(value.id, anchor: .center)
                    }
                }
            }
        }
        .frame(height: 48)
    }
}
