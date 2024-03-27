//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ColorSet
import ComposableArchitecture

public struct NoticeTypeColumn: View {
    public let title: String
    public let provider: NoticeProvider
    public let selection: NoticeProvider
    
    private var isSelceted: Bool {
        provider.category == .학과
        ? selection.category == .학과
        : provider.id == selection.id
    }
    
    public var body: some View {
        let itemSize = CGSize(width: 64, height: 48)
        let lineHeight: CGFloat = 3

        Text(title)
            .font(.system(size: 16, weight: isSelceted ? .semibold : .medium))
            .padding(.vertical, 8)
            .frame(width: itemSize.width, height: itemSize.height)
            .overlay {
                VStack {
                    Spacer()

                    RoundedRectangle(cornerRadius: lineHeight / 2)
                        .frame(width: itemSize.width, height: lineHeight)
                        .opacity(isSelceted ? 1 : 0)
                }
            }
            .foregroundStyle(
                isSelceted
                ? Color.Kuring.primary
                : Color.Kuring.caption1
            )
            .id(provider.id) // 자동 스크롤
    }

    /// - Parameter key: 보여질 텍스트 값
    public init(key: String, provider: NoticeProvider, selection: NoticeProvider) {
        self.title = key
        self.provider = provider
        self.selection = selection
    }
}
