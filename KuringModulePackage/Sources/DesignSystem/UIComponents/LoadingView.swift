//
//  LoadingView.swift
//
//
//  Created by 🏝️ GeonWoo Lee on 10/4/23.
//

import SwiftUI
import ColorSet

public struct LoadingView: View {
    let size: CGSize = CGSize(width: 10, height: 10)
    
    @State var isAnimating1: Bool = false
    @State var isAnimating2: Bool = false
    @State var isAnimating3: Bool = false
    
    public var body: some View {
        HStack(spacing: 5) {
            circle
                .offset(y: isAnimating1 ? 12 : -5)
                .animation(.easeInOut(duration: 0.5).repeatForever(),
                           value: isAnimating1)
            circle
                .offset(y: isAnimating2 ? 12 : -5)
                .animation(.easeInOut(duration: 0.5).repeatForever(),
                           value: isAnimating2)
            circle
                .offset(y: isAnimating3 ? 12 : -5)
                .animation(.easeInOut(duration: 0.5).repeatForever(),
                           value: isAnimating3)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                isAnimating1 = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating2 = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isAnimating3 = true
            }
        }
    }
    
    private var circle: some View {
        Circle()
            .frame(width: size.width, height: size.height)
            .foregroundStyle(ColorSet.green.color)
    }
}

#Preview {
    LoadingView()
}
