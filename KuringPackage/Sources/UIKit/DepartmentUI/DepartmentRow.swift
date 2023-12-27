import Models
import SwiftUI
import ColorSet
import DepartmentFeatures

struct DepartmentRow: View {
    let department: NoticeProvider
    let style: ButtonStyle
    let action: () -> Void
    
    enum ButtonStyle {
        case delete
        case radio(Bool)
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text(department.korName)
            
            Spacer()
            
            switch style {
            case .delete:
                Button(action: action) {
                    Text("삭제")
                        .foregroundStyle(Color.caption1.opacity(0.6))
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
                        ? Color.accentColor
                        : Color.black.opacity(0.1)
                    )
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 10)
    }
}

#Preview {
    Group {
        DepartmentRow(department: .국제, style: .delete) { }
    
        DepartmentRow(department: .국제, style: .radio(true)) { }
        
        DepartmentRow(department: .국제, style: .radio(false)) { }
    }
}
