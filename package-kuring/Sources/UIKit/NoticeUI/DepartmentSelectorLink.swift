//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ColorSet

struct DepartmentSelectorLink: View {
    let department: NoticeProvider
    @Binding var isLoading: Bool
    let action: () -> Void

    var body: some View {
        HStack {
            Text(department.korName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.Kuring.title)

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
        // 액션 정의. 예) `store.send(.changeDepartmentButtonTapped)`
    }
}
