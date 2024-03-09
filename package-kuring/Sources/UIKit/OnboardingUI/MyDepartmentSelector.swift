//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Lottie
import Models
import SwiftUI
import ColorSet
import Networks
import DepartmentUI

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
                        NoticeProvider.addedDepartments.append(selectedDepartment)
                    }
                    currentStep = .addedDepartment.id
                }
                .buttonStyle(.kuringStyle())
                
                Button(StringSet.button_again.rawValue) {
                    currentStep = .searchDepartment.id
                    selectedDepartment = nil
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.caption1.opacity(0.6))
                .padding(.vertical, 20)
            } else {
                Button(StringSet.button_start.rawValue) {
                    dismiss()
                }
                .buttonStyle(.kuringStyle(enabled: currentStep == .addedDepartment.id))
            }
        }
        .padding(.horizontal, 20)
        .onChange(of: selectedDepartment) { _, _ in
            guard selectedDepartment != nil else { return }
            currentStep = .selectDepartment.id
        }
    }
}

extension MyDepartmentSelector {
    struct DepartmentSelector: View {
        @State private var searchKeyword: String = ""
        @State private var results: [NoticeProvider] = [
            NoticeProvider(
                name: "education",
                hostPrefix: "edu",
                korName: "교직과",
                category: .학과
            ),
            NoticeProvider(
                name: "physical_education",
                hostPrefix: "kupe",
                korName: "체육교육과",
                category: .학과
            ),
            NoticeProvider(
                name: "computer_science",
                hostPrefix: "cse",
                korName: "컴퓨터공학부",
                category: .학과
            ),
        ]
        @FocusState private var focus: Bool
        
        @Binding var selectedDepartment: NoticeProvider?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text(StringSet.title_select.rawValue)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                
                Text(StringSet.description_select.rawValue)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.caption1.opacity(0.6))
                
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.caption1.opacity(0.6))
                    
                    TextField("추가할 학과를 검색해 주세요", text: $searchKeyword)
                        .focused($focus)
                        .autocorrectionDisabled()
                    
                    if searchKeyword.isEmpty {
                        Image(systemName: "xmark")
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.caption1.opacity(0.6))
                            .onTapGesture {
                                searchKeyword = ""
                                focus = false
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 7)
                .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                .cornerRadius(20)
                .padding(.bottom, 16)
                
                ScrollView {
                    ForEach(results) { result in
                        DepartmentRow(
                            department: result,
                            style: .radio(false)
                        ) {
                            selectedDepartment = result
                        }
                    }
                }
                
                Spacer()
            }
            .onChange(of: searchKeyword) { _, _ in
                search()
            }
        }
        
        func search() {
            var correctResults = NoticeProvider.departments
                .filter { $0.korName.contains(searchKeyword) }
                .compactMap { $0 }
                .sorted { $0.korName < $1.korName }
            
            NoticeProvider.departments.forEach { department in
                var count = 0
                var textChecker = Array(repeating: 0, count: searchKeyword.count)
                for alpha in department.korName {
                    for (idx, value) in searchKeyword.enumerated() {
                        if value == alpha && textChecker[idx] == 0 {
                            textChecker[idx] = 1
                            count += 1
                            break
                        }
                    }
                }
                if count == searchKeyword.count && !correctResults.contains(department) {
                    correctResults.append(department)
                }
            }
            results = correctResults
        }
    }
}

extension MyDepartmentSelector {
    struct ConfirmationView: View {
        let department: NoticeProvider
        
        var body: some View {
            VStack {
                HStack(spacing: 0) {
                    Text(department.korName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.accentColor)
                    
                    Text(
                        department.korName.last == "공"
                        ? "을"
                        : "를"
                    )
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                }
                
                Text(StringSet.title_confirm.rawValue)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                
                Text(StringSet.description_confirm.rawValue)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.caption1.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                
                Spacer()
            }
            .padding(.top, 124)
        }
    }
}

extension MyDepartmentSelector {
    struct CompletionView: View {
        var body: some View {
            VStack(spacing: 12) {
                Text(StringSet.title_complete.rawValue)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                
                Text(StringSet.description_complete.rawValue)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.caption1.opacity(0.6))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                LottieView(animation: .named("success.json", bundle: Bundle.onboarding))
                    .playing()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .clipped()
                
                Spacer()
            }
            .padding(.top, 124)
        }
    }
}

extension MyDepartmentSelector {
    enum Step: Identifiable {
        case searchDepartment
        case selectDepartment
        case addedDepartment
        
        var id: Self { self }
    }
}
extension MyDepartmentSelector {
    enum StringSet: String {
        case title_select = "전공학과를\n설정해주세요"
        case description_select = "학과 공지 알림을 받아볼 수 있도록\n전공 학과를 설정해 주세요"
        case button_complete = "학과 설정 완료"
        case button_again = "다시 설정하기"
        case button_start = "쿠링 시작하기"
        case title_confirm = "내 전공학과로 설정할까요?"
        case description_confirm = "혹시 다전공/부전공을 하고 계신가요?\n쿠링을 시작하면 더 많은 전공을 추가할 수 있어요!"
        case title_complete = "학과 설정이 완료되었어요!"
        case description_complete = "이제 쿠링과 함께\n즐겁고 편리한 캠퍼스를 누려봐요!"
    }
}

#Preview {
    MyDepartmentSelector()
}

#Preview {
    MyDepartmentSelector.ConfirmationView(department: NoticeProvider(
        name: "영상영화학과",
        hostPrefix: "영상영화학과",
        korName: "영상영화학과",
        category: .학과)
    )
}

#Preview {
    MyDepartmentSelector.CompletionView()
}
