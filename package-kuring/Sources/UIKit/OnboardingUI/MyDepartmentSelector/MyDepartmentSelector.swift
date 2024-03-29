//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import SwiftUI
import ColorSet
import Dependencies

struct MyDepartmentSelector: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Step.ID = .searchDepartment.id
    @State private var selectedDepartment: NoticeProvider? = nil
    
    var body: some View {
        VStack {
            // 메인 영역
            TabView(selection: $currentStep) {
                DepartmentSelector(selectedDepartment: $selectedDepartment)
                    .tag(Step.searchDepartment.id)
                
                if let selectedDepartment {
                    ConfirmationView(department: selectedDepartment)
                        .tag(Step.selectDepartment.id)
                }
                
                CompletionView()
                    .tag(Step.addedDepartment.id)
            }
            .padding(.top, 56)
            
            // 하단 버튼 영역
            if currentStep == .selectDepartment {
                Button(StringSet.button_complete.rawValue) {
                    if let selectedDepartment {
                        @Dependency(\.departments) var departments
                        NoticeProvider.addedDepartments.append(selectedDepartment)
                        departments.add(selectedDepartment)
                    }
                    currentStep = .addedDepartment.id
                }
                .buttonStyle(.kuringStyle())
                
                Button(StringSet.button_again.rawValue) {
                    currentStep = .searchDepartment.id
                    selectedDepartment = nil
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
                .padding(.vertical, 20)
            } else {
                Button(StringSet.button_start.rawValue) {
                    dismiss()
                }
                .buttonStyle(.kuringStyle(enabled: currentStep == .addedDepartment.id))
            }
        }
        .padding(.horizontal, 20)
        .background(Color.Kuring.bg)
        .onChange(of: selectedDepartment) { _, _ in
            guard selectedDepartment != nil else { return }
            currentStep = .selectDepartment.id
        }
    }
}

#Preview {
    MyDepartmentSelector()
}
