import Models
import SwiftUI

struct DepartmentSelectorLink: View {
    let department: NoticeProvider
    @Binding var isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(department.korName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.black.opacity(0.8))
            
            Spacer()
            
            if isLoading {
                ProgressView()
            } else {
                Image(systemName: "chevron.right")
            }
        }
        .contentShape(Rectangle())
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .onTapGesture {
            guard !isLoading else { return }
            action()
        }
    }
}

#Preview {
    DepartmentSelectorLink(
        department: .init(name: "산업디자인학과", hostPrefix: "kuid", korName: "산업디자인학과", category: .학과),
        isLoading: .constant(false)
    ) {
        // 액션 정의. 예) `viewStore.send(.changeDepartmentButtonTapped)`
    }
}