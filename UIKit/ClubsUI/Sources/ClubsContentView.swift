//
//  ClubsContentView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/8/26.
//

import SwiftUI

public struct ClubsContentView: View {
    @State private var selection: String = "전체"
    
    public init() { }
    
    public var body: some View {
        VStack(spacing: 0) {
            ClubsCategoryPicker(selection: $selection)
                .padding(.horizontal, 20)
            
            Divider()
                .frame(height: 0.25)
            
            ClubsTagSelector()
                .padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ClubsContentView()
}
