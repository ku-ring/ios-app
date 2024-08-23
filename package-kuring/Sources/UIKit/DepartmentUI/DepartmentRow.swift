//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ColorSet
import Dependencies
import DepartmentFeatures

public struct DepartmentRow: View {
    public let department: NoticeProvider
    public let style: ButtonStyle

    public enum ButtonStyle {
        case delete
        case radio(Bool)
    }
    
    @Dependency(\.departments) var departments

    public var body: some View {
        HStack(alignment: .center) {
            Text(department.korName)
            
            if departments.getCurrent()?.id == department.id {
                RepresentativeDepartmentChip
            }

            Spacer()

            switch style {
            case .delete:
                Text("삭제")
                    .foregroundStyle(Color.Kuring.caption1)
            case let .radio(isSelected):
                Image(
                    systemName: isSelected
                    ? "checkmark.circle.fill"
                    : "plus.circle"
                )
                .foregroundStyle(
                    isSelected
                    ? Color.Kuring.primary
                    : Color.Kuring.gray200
                )
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 10)
    }
    
    public init(department: NoticeProvider, style: ButtonStyle) {
        self.department = department
        self.style = style
    }
    
    /// 대표 학과 여부를 나타내는 칩
    private var RepresentativeDepartmentChip: some View {
        Text("대표")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color.Kuring.primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Color.Kuring.primarySelected)
            .clipShape(Capsule())
    }
}

#Preview {
    Group {
        DepartmentRow(department: .국제, style: .delete)

        DepartmentRow(department: .국제, style: .radio(true))

        DepartmentRow(department: .국제, style: .radio(false))
    }
}
