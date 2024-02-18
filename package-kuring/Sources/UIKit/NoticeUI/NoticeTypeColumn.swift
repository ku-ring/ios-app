//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ComposableArchitecture

public struct NoticeTypeColumn: View {
    public let provider: NoticeProvider
    public let selectedID: NoticeProvider.ID

    public var body: some View {
        let itemSize = CGSize(width: 64, height: 48)
        let lineHeight: CGFloat = 3

        Text(provider.korName)
            .font(.system(size: 16, weight: provider.id == selectedID ? .semibold : .regular))
            .padding(.vertical, 8)
            .frame(width: itemSize.width, height: itemSize.height)
            .overlay {
                VStack {
                    Spacer()

                    RoundedRectangle(cornerRadius: lineHeight / 2)
                        .frame(width: itemSize.width, height: lineHeight)
                        .opacity(provider.id == selectedID ? 1 : 0)
                }
            }
            .foregroundStyle(
                provider.id == selectedID
                    ? Color.accentColor
                    : Color.black.opacity(0.3)
            )
            .id(provider.id)
    }

    public init(provider: NoticeProvider, selectedID: NoticeProvider.ID) {
        self.provider = provider
        self.selectedID = selectedID
    }
}
