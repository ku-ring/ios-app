//
//  ClubsAffiliationSelectionSheet.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/12/26.
//

import Models
import SwiftUI
import ColorSet

struct ClubsAffiliationSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss

    let division: [Division]
    @Binding var selectedDivisions: Set<Division>

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("동아리 소속 선택")
                .font(.system(size: 18, weight: .bold))

            ScrollView {
                FlowLayout(spacing: 10) {
                    ForEach(division, id: \.self) { division in
                        tagButton(
                            title: division.koreanName,
                            isSelected: selectedDivisions.contains(division)
                        ) {
                            if selectedDivisions.contains(division) {
                                selectedDivisions.remove(division)
                            } else {
                                selectedDivisions.insert(division)
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
}

// MARK: - Subviews
private extension ClubsAffiliationSelectionSheet {
    
    var bottomButtons: some View {
        GeometryReader { proxy in
            HStack(alignment: .bottom, spacing: 16) {
                resetButton(width: (proxy.size.width - 40 - 16) / 3)
                confirmButton
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(height: 56)
    }

    func resetButton(width: CGFloat) -> some View {
        Button {
            selectedDivisions.removeAll()
        } label: {
            Text("초기화")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.Kuring.caption1)
                .frame(width: width)
                .padding()
                .background(
                    Capsule()
                        .fill(Color.Kuring.bg)
                        .stroke(Color.Kuring.gray200, lineWidth: 1)
                )
        }
    }

    var confirmButton: some View {
        let hasSelection = !selectedDivisions.isEmpty
        return Button {
            dismiss()
        } label: {
            Text("확인 (\(selectedDivisions.count))")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(hasSelection ? Color.Kuring.primary : Color.Kuring.gray200)
                .foregroundStyle(hasSelection ? Color.Kuring.bg : Color.Kuring.caption1)
                .clipShape(Capsule())
        }
        .disabled(!hasSelection)
    }

    func tagButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                action()
            }
        } label: {
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
