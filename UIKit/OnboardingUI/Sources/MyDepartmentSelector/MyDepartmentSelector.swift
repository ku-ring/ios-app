//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import SwiftUI
import ColorSet
import Networks
import Dependencies

struct MyDepartmentSelector: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Step = .searchDepartment
    @State private var selectedDepartment: NoticeProvider? = nil
    
    @Dependency(\.commons) var commons
    @Dependency(\.kuringLink) var kuringLink
    @Dependency(\.departments) var departments
    @Dependency(\.subscriptions) var subscriptions

    var body: some View {
        VStack {
            contentView
            bottomView
        }
        .padding(.horizontal, 20)
        .background(Color.Kuring.bg)
        .onChange(of: selectedDepartment) { _, _ in
            guard selectedDepartment != nil else { return }
            currentStep = .selectDepartment
        }
    }
    
    //MARK: - 메인 영역
    private var contentView: some View {
        Group {
            switch currentStep {
            case .searchDepartment:
                DepartmentSelector(selectedDepartment: $selectedDepartment)
            case .selectDepartment:
                if let selectedDepartment {
                    ConfirmationView(department: selectedDepartment)
                }
            case .addedDepartment:
                CompletionView()
            }
        }
        .padding(.top, 56)
    }
    
    //MARK: - 하단 버튼 영역
    @ViewBuilder
    private var bottomView: some View {
        
        if case let .selectDepartment = currentStep {
            Button(StringSet.button_complete.rawValue) {
                handleDepartmentSelection()
                currentStep = .addedDepartment
            }
            .buttonStyle(.kuringStyle())
            
            Button(StringSet.button_again.rawValue) {
                currentStep = .searchDepartment
                selectedDepartment = nil
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(Color.Kuring.caption1)
            .padding(.vertical, 20)
        } else {
            Button(StringSet.button_start.rawValue) {
                commons.completeOnboarding()
                dismiss()
            }
            .buttonStyle(.kuringStyle(enabled: currentStep == .addedDepartment))
            .padding(.bottom, 16)
        }
    }
    
    //MARK: - Department selection action
    private func handleDepartmentSelection() {
        if let selectedDepartment {
            // 로컬 저장소에 학과 추가
            NoticeProvider.addedDepartments.append(selectedDepartment)
            departments.add(selectedDepartment)
            
            Task(priority: .background) {
                // 추가한 학과 구독, 단 api 성공시에만 구독정보 저장
                do {
                    try await kuringLink.subscribeDepartments([selectedDepartment.hostPrefix])
                    subscriptions.add(selectedDepartment)
                }
            }
        }
    }
}

#Preview {
    MyDepartmentSelector()
}
