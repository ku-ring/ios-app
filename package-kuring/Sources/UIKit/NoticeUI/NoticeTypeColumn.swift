//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ComposableArchitecture

public struct NoticeTypeColumn: View {
    public let noticeType: NoticeType
    public let selectedID: NoticeType.ID

    public var body: some View {
        let itemSize = CGSize(width: 64, height: 48)
        let lineHeight: CGFloat = 3

        Text(noticeType.rawValue)
            .font(.system(size: 16, weight: noticeType.id == selectedID ? .semibold : .regular))
            .padding(.vertical, 8)
            .frame(width: itemSize.width, height: itemSize.height)
            .overlay {
                VStack {
                    Spacer()

                    RoundedRectangle(cornerRadius: lineHeight / 2)
                        .frame(width: itemSize.width, height: lineHeight)
                        .opacity(noticeType.id == selectedID ? 1 : 0)
                }
            }
            .foregroundStyle(
                noticeType.id == selectedID
                    ? Color.accentColor
                    : Color.black.opacity(0.3)
            )
            .id(noticeType.id)
    }

    public init(noticeType: NoticeType, selectedID: NoticeType.ID) {
        self.noticeType = noticeType
        self.selectedID = selectedID
    }
}
