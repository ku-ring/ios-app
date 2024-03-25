//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ColorSet
import DepartmentFeatures

public struct DepartmentRow: View {
    public let department: NoticeProvider
    public let style: ButtonStyle
    public let action: () -> Void

    public enum ButtonStyle {
        case delete
        case radio(Bool)
    }

    public var body: some View {
        HStack(alignment: .center) {
            Text(department.korName)

            Spacer()

            switch style {
            case .delete:
                Button(action: action) {
                    Text("삭제")
                        .foregroundStyle(Color.Kuring.caption1)
                }
            case let .radio(isSelected):
                Button(action: action) {
                    Image(
                        systemName: isSelected
                        ? "checkmark.circle.fill"
                        : "plus.circle"
                    )
                    .foregroundStyle(
                        isSelected
                        ? Color.Kuring.primary
                        : Color.Kuring.gray400
                    )
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 10)
    }
    
    public init(department: NoticeProvider, style: ButtonStyle, action: @escaping () -> Void) {
        self.department = department
        self.style = style
        self.action = action
    }
}

#Preview {
    Group {
        DepartmentRow(department: .국제, style: .delete) { }

        DepartmentRow(department: .국제, style: .radio(true)) { }

        DepartmentRow(department: .국제, style: .radio(false)) { }
    }
}
