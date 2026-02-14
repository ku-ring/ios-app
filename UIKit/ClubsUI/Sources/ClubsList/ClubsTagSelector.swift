//
//  ClubsTagSelector.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/8/26.
//

import SwiftUI
import ColorSet

public struct ClubsTagSelector: View {
    let tags = ["중앙동아리", "문과대학", "이과대학", "건축대학", "공과대학", "사회과학대학", "경영대학", "부동산과학원", "융합과학기술원", "생명과학대학", "수의과대학", "예술디자인대학", "사범대학", "KU자유전공학부",
                "상허교양대학"]

    @State private var selectedTags: Set<String> = []
    @Binding var showAffiliationSelectionSheet: Bool
    
    public init(showAffiliationSelectionSheet: Binding<Bool>) {
        self._showAffiliationSelectionSheet = showAffiliationSelectionSheet
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                // 초기화 버튼 (선택된 게 있을 때만)
                if !selectedTags.isEmpty {
                    Button {
                        selectedTags.removeAll()
                    } label: {
                        Image("refresh-cw", bundle: .module)
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.Kuring.gray400)
                            .padding(.vertical, 6.5)
                            .padding(.horizontal, 14)
                            .background(
                                Capsule()
                                    .fill(Color.Kuring.bg)
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(
                                              Color.Kuring.gray200,
                                              lineWidth: 1
                                            )
                                    )
                            )
                    }
                }

                ForEach(tags, id: \.self) { tag in
                    ClubsTag(
                        title: tag,
                        isSelected: selectedTags.contains(tag)
                    ) {
                        toggle(tag)
                    }
                }
                .frame(height: 37)
            }
            .padding(.trailing, 37)
        }
        .overlay(alignment: .trailing) {
            LinearGradient(
                colors: [Color.Kuring.bg, Color.clear],
                startPoint: .center,
                endPoint: .leading
            )
            .frame(width: 59, height: 37, alignment: .trailing)
            .overlay(alignment: .trailing) {
                Image(systemName: "chevron.down")
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.Kuring.gray300)
                    .onTapGesture {
                        showAffiliationSelectionSheet = true
                    }
            }
        }
        .padding(.top, 16)
    }

    // Use Transaction to disable all animation
    private func toggle(_ tag: String) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            if selectedTags.contains(tag) {
                selectedTags.remove(tag)
            } else {
                selectedTags.insert(tag)
            }
        }
    }
}

#Preview {
    ClubsTagSelector(showAffiliationSelectionSheet: .constant(true))
}
