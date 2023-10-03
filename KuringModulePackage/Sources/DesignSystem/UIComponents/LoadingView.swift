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
    
    public var body: some View {
        HStack(spacing: 5) {
            circle
            circle
            circle
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
