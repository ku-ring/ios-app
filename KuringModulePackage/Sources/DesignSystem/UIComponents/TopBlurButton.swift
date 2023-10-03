//
//  TopBlurButton.swift
//
//
//  Created by 🏝️ GeonWoo Lee on 10/2/23.
//

import Model
import SwiftUI
import ColorSet

public struct TopBlurButton: View {
    let title: String
    let fontColor: Color
    let backgroundColor: Color
    
    public init(_ title: String, fontColor: Color, backgroundColor: Color) {
        self.title = title
        self.fontColor = fontColor
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(fontColor)
            Spacer()
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 16)
        .frame(height: 50, alignment: .center)
        .background(backgroundColor)
        .cornerRadius(100)
        .background {
            LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white]), startPoint: .top, endPoint: .bottom)
                .offset(x: 0, y: -32)
        }
    }
}

#Preview {
    VStack {
        Rectangle()
            .foregroundStyle(Color.red)
            .frame(height: 40)
        TopBlurButton(
            "쿠링",
            fontColor: ColorSet.Background.green,
            backgroundColor: ColorSet.Background.green.opacity(0.15))
        
        Rectangle()
            .frame(height: 10)
        Rectangle()
            .foregroundStyle(Color.red)
            .frame(height: 40)
        TopBlurButton(
            "쿠링",
            fontColor: .white,
            backgroundColor: ColorSet.Background.green)
        
        
        Spacer()
    }
}
