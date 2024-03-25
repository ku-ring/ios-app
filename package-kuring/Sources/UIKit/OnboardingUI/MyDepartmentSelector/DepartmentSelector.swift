//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import Combine
import SwiftUI
import ColorSet
import DepartmentUI

@Observable
class DepartmentFinder {
    // TODO: 디바운스 적용 필요
    // Usually you don't need debounce in SwiftUI because all state changes are debounced already, that is you can set the state many times but body will only be called once afterwards.
    // 만약 적용 필요시 **AsyncAlgorithms** 패키지 사용
    // `.debounce(for: .seconds(1), scheduler: RunLoop.main)`
    // `.sink { [weak self] output }` 안먹힘
    // `.onReceive(finder.searchKeyword.publisher)` 도 안먹힘
    var text: String = "" {
        didSet { search(self.text) }
    }
    
    /// 검색 결과
    var results: [NoticeProvider] = []
    
    func search(_ keyword: String) {
        var correctResults = NoticeProvider.departments
            .filter { $0.korName.contains(keyword) }
            .compactMap { $0 }
            .sorted { $0.korName < $1.korName }
        
        NoticeProvider.departments.forEach { department in
            var count = 0
            var textChecker = Array(repeating: 0, count: keyword.count)
            for alpha in department.korName {
                for (idx, value) in keyword.enumerated() {
                    if value == alpha && textChecker[idx] == 0 {
                        textChecker[idx] = 1
                        count += 1
                        break
                    }
                }
            }
            if count == keyword.count && !correctResults.contains(department) {
                correctResults.append(department)
            }
        }
        results = correctResults
    }
}

struct DepartmentSelector: View {
    @State private var finder = DepartmentFinder()
    
    @FocusState private var focus: Bool
    
    @Binding var selectedDepartment: NoticeProvider?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(StringSet.title_select.rawValue)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.Kuring.title)
            
            Text(StringSet.description_select.rawValue)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
            
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color.Kuring.gray400)
                
                TextField("추가할 학과를 검색해 주세요", text: $finder.text)
                    .focused($focus)
                    .autocorrectionDisabled()
                
                if !finder.text.isEmpty {
                    Image(systemName: "xmark")
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.Kuring.caption1.opacity(0.6))
                        .onTapGesture {
                            finder.text = ""
                            focus = false
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 7)
            .background(Color.Kuring.gray100)
            .cornerRadius(20)
            .padding(.bottom, 16)
            
            ScrollView {
                ForEach(finder.results) { result in
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
        .background(Color.Kuring.bg)
    }
}
