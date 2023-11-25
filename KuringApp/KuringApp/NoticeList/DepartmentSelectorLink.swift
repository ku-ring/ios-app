//
//  DepartmentSelectorLink.swift
//  KuringApp
//
//  Created by 이재성 on 11/24/23.
//

import Model
import SwiftUI

struct DepartmentSelectorLink: View {
    let department: NoticeProvider
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(department.korName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.black.opacity(0.8))
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .onTapGesture(perform: action)
    }
}

#Preview {
    DepartmentSelectorLink(
        department: .init(name: "산업디자인학과", hostPrefix: "kuid", korName: "산업디자인학과", category: .학과)
    ) {
        // 액션 정의. 예) `viewStore.send(.changeDepartmentButtonTapped)`
    }
}
