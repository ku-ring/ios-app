//
//  TransparentBlurView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/13/26.
//

import SwiftUI

struct TransparentBlurView: View {
    var blur: CGFloat = 6
    var color: Color = .white.opacity(0.2)
    
    var body: some View {
        TransparentBlur()
            .blur(radius: blur, opaque: true)
            .overlay {
                color
            }
    }
}

struct TransparentBlur: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            if let backdropLayer = uiView.layer.sublayers?.first {
                backdropLayer.filters = []
            }
        }
    }
}
