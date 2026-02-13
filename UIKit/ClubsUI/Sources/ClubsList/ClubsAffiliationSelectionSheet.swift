//
//  ClubsAffiliationSelectionSheet.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/12/26.
//

import SwiftUI
import ColorSet

struct ClubsAffiliationSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    let categories = [
        "중앙동아리", "문과대학", "이과대학", "건축대학",
        "공과대학", "사회과학대학", "경영대학",
        "부동산과학원", "융합과학기술원", "생명과학대학",
        "수의과대학", "예술디자인대학", "사범대학",
        "KU자유전공학부", "상허교양대학"
    ]
    
    @State private var selected: Set<String> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("동아리 소속 선택")
                .font(.system(size: 18, weight: .bold))
            
            ScrollView {
                FlowLayout(spacing: 10) {
                    ForEach(categories, id: \.self) { item in
                        tagButton(
                            title: item,
                            isSelected: selected.contains(item)
                        ) {
                            if selected.contains(item) {
                                selected.remove(item)
                            } else {
                                selected.insert(item)
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            bottomButtons
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 12)
        .background(Color.Kuring.bg)
    }
    
    var bottomButtons: some View {
        HStack(alignment: .bottom, spacing: 12) {
            Button {
                selected.removeAll()
            } label: {
                Text("초기화")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.Kuring.caption1)
                    .frame(width: (UIScreen.main.bounds.size.width - 40 - 16) / 3)
                    .padding()
                    .background(
                        Capsule()
                            .fill(Color.Kuring.bg)
                            .stroke(Color.Kuring.gray200, lineWidth: 1)
                    )
            }
            
            Button {
                dismiss()
            } label: {
                Text("확인 (\(selected.count))")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selected.isEmpty ? Color.Kuring.gray200 : Color.Kuring.primary)
                    .foregroundStyle(selected.isEmpty ? Color.Kuring.caption1 : Color.Kuring.bg)
                    .clipShape(Capsule())
            }
            .disabled(selected.isEmpty)
        }
    }
    
    @ViewBuilder
    private func tagButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                action()
            }
        }) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(isSelected ? Color.Kuring.primary : Color.Kuring.caption1)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                          .fill(isSelected ? Color.Kuring.primarySelected : Color.Kuring.bg)
                          .overlay(
                              Capsule()
                                  .strokeBorder(
                                    isSelected ? Color.Kuring.primary : Color.Kuring.gray200,
                                    lineWidth: 1
                                  )
                          )
                )
        }
    }
}

#Preview {
    ClubsAffiliationSelectionSheet()
}
