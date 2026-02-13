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
    @State private var showAffiliationSheet: Bool = false
    
    let isClubEmpty = false
    
    public init() { }
    
    public var body: some View {
        VStack(spacing: 0) {
            ClubsCategoryPicker(selection: $selection)
                .padding(.horizontal, 20)
            
            Divider()
                .frame(height: 0.25)
            
            ClubsTagSelector(showAffiliationSelectionSheet: $showAffiliationSheet)
                .padding(.horizontal, 20)

            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    sortByView
                        .frame(height: 32)
                        .padding(.horizontal, 20)
                    
                    if isClubEmpty {
                        clubsEmptyView
                    } else {
                        VStack(spacing: 14) {
                            ClubCardView()
                            
                            ClubCardView()
                            
                            ClubCardView()
                            
                            ClubCardView()
                            
                            ClubCardView()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    }
                }
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.Kuring.bg)
        .sheet(isPresented: $showAffiliationSheet) {
            ClubsAffiliationSelectionSheet()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
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
                
                Text("가나다 순")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.Kuring.caption2)
            }
        }
    }
    
    private var clubsEmptyView: some View {
        VStack(alignment: .center, spacing: 16) {
            Image("alert-circle", bundle: .module)
                .resizable()
                .frame(width: 57, height: 57)
            
            Text("등록된 동아리가 없어요!")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
        }
        .padding(.top, 120)
    }
}

#Preview {
    ClubsContentView()
}
