//
//  ClubsContentView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/8/26.
//

import SwiftUI
import ColorSet

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
            
            sortByView
                .frame(height: 32)
                .padding(.top, 16)
                .padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.Kuring.bg)
    }
    
    private var sortByView: some View {
        HStack {
            Text("총 67개")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.Kuring.caption1)
            
            Spacer()
            
            HStack(spacing: 9) {
                Text("모집 마감일 순")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)
                
                Divider()
                    .frame(width: 1)
                    .foregroundStyle(Color.Kuring.gray200)
                    .padding(.vertical, 8)
                
                Text("모집 마감일 순")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.Kuring.caption2)
            }
        }
    }
}

#Preview {
    ClubsContentView()
}
