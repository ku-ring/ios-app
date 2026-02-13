//
//  ClubCardView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/9/26.
//

import SwiftUI
import ColorSet

struct ClubCardView: View {
    @State private var isSubscribed: Bool = false
    
    var body: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.Kuring.gray100)
                .frame(width: 84)
                .overlay(alignment: .center) {
                    Image("kuring_icon", bundle: .module)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28)
                        .foregroundStyle(Color.Kuring.gray200)
                }
            
            VStack(alignment: .leading) {
                HStack {
                    Text("릴스 시청 동아리")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.Kuring.title)
                    
                    Spacer()
                    
                    clubInfoChips(text: "D-3")
                }
                
                Text("매주 목요일 학생회관\n릴스 100번 넘기기")
                    .padding(.top, 4)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.Kuring.caption1)
                
                Spacer()
                
                HStack {
                    clubInfoChips(text: "학술활동")
                    
                    clubInfoChips(text: "중앙동아리")
                    
                    Spacer()
                    
                    Text("99+")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.Kuring.caption1)
                    
                    Image(isSubscribed ? "star.fill" : "star", bundle: .module)
                        .resizable()
                        .frame(width: 16, height: 16, alignment: .center)
                        .foregroundStyle(Color.Kuring.gray300)
                        .onTapGesture {
                            isSubscribed.toggle()
                        }
                }
            }
        }
        .frame(height: 132)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Kuring.bg)
                .stroke(Color.Kuring.gray100, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func clubInfoChips(text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color.Kuring.caption1)
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.Kuring.gray100)
            )
    }
}

#Preview {
    ClubCardView()
        .padding(.horizontal, 20)
}
