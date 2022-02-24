//
//  OnboardingRow.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/02/24.
//

import SwiftUI

struct OnboardingRow: View {
    let systemName: String
    let uiColor: UIColor
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(uiColor.color)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.footnote)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 16)
    }
}
