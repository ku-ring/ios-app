//
//  SwiftUIView.swift
//  KuringApp
//
//  Created by 🏝️ GeonWoo Lee on 9/29/23.
//

import SwiftUI

struct Test: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<4, id: \.self) { department in
                VStack(spacing: 0) {
                    HStack {
                        Text("asdfasdf")
                        Spacer()
                        Image(systemName: "checkmark.circle")
                    }
                    if department != 3 {
                        Rectangle()
                            .frame(height: 1.5)
                            .foregroundColor(.red)
                            .padding(.top, 16)
                            .padding(.bottom, 16)
                        
                    }
                }
                .padding(.horizontal, 21.5)
                
            }
        }
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.black.opacity(0.03))
        )
        Spacer()
    }
}

#Preview {
    Test()
}
