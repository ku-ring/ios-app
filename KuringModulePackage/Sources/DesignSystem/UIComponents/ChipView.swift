//
//  ChipView.swift
//
//
//  Created by 🏝️ GeonWoo Lee on 10/2/23.
//

import SwiftUI
import ColorSet

public struct ChipView: View {
    /// 칩에 들어가는 텍스트
    let title: String
    /// 칩의 사이즈
    let chipSize: CGSize
    /// 칩 아래의 라인 사이즈
    let lineHeight: CGFloat
    /// 칩 라인 visbile 여부
    let lineVisible: Bool
    
    public init(_ title: String, chipSize: CGSize, lineHeight: CGFloat, lineVisible: Bool) {
        self.title = title
        self.chipSize = chipSize
        self.lineHeight = lineHeight
        self.lineVisible = lineVisible
    }
    
    public var body: some View {
        Text(title)
            .padding(.top, 8)
            .padding(.bottom, 8 + lineHeight)
            .frame(width: chipSize.width, height: chipSize.height)
            .overlay {
                VStack {
                    Spacer()
                    
                    if lineVisible {
                        RoundedRectangle(cornerRadius: 3)
                            .frame(height: lineHeight)
                    } else {
                        Spacer()
                            .frame(height: lineHeight)
                    }
                }
            }
    }
}

#Preview {
    HStack(spacing: 0) {
        let chipSize = CGSize(width: 64, height: 48)
        let lineHeight: CGFloat = 3
        ChipView("쿠링", chipSize: chipSize, lineHeight: lineHeight, lineVisible: true)
            .foregroundStyle(ColorSet.green.color)
        ChipView("쿠링", chipSize: chipSize, lineHeight: lineHeight, lineVisible: false)
            .foregroundStyle(ColorSet.Label.gray.color.opacity(0.5))
    }
    .font(.system(size: 16, weight: .semibold))
}
