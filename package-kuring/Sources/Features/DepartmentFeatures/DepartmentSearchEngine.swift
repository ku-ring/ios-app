//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import ComposableArchitecture

protocol DepartmentSearchEngine {
    func search(keyword: String, allDepartments: IdentifiedArrayOf<NoticeProvider>) -> IdentifiedArrayOf<NoticeProvider>
}

struct DepartmentSearchEngineImpl: DepartmentSearchEngine {
    /// 한글
    private var hangeul = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
    
    
    /// 전체학과 정보와 주어진 검색 키워드를 기반으로 검색된 학과 리스트를 반환
    ///
    ///
    /// - Parameters:
    ///     - keyword: 검색 키워드
    ///     - allDepartments: 모든 학과 리스트
    func search(keyword: String, allDepartments: IdentifiedArrayOf<NoticeProvider>) -> IdentifiedArrayOf<NoticeProvider> {
        var filteredDepartments: IdentifiedArrayOf<NoticeProvider>
        
        if isChosung(keyword) {
            let results = allDepartments.filter { department in
                department.korName.contains(keyword) || searchChosung(department.korName).contains(keyword)
            }
            
            filteredDepartments = results
        } else {
            var correctResults = allDepartments
                .filter { $0.korName.contains(keyword) }
                .compactMap { $0 }
                .sorted { $0.korName < $1.korName }
               
            allDepartments.forEach { department in
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
            filteredDepartments = IdentifiedArray(correctResults)
        }
        
        return filteredDepartments
    }
    
    /// 해당 keyword가 초성문자인지 검사
    private func isChosung(_ keyword: String) -> Bool {
        var result = false
        
        for char in keyword {
            if 0 < hangeul.filter({ $0.contains(char) }).count {
                result = true
            } else {
                result = false
                break
            }
        }
        
        return result
    }
    
    /// 초성 검색
    private func searchChosung(_ keyword: String) -> String {
        var result = ""
        
        for char in keyword {
            // unicodeScalars: 유니코드 스칼라 값의 모음으로 표현되는 문자열 값
            let octal = char.unicodeScalars[char.unicodeScalars.startIndex].value
            
            // ~=: 왼쪽에서 정의한 범위 값 안에 오른쪽의 값이 속하면 true, 아니면 false 반환
            if 44032...55203 ~= octal {
                let index = (octal - 0xac00) / 28 / 21
                result = result + hangeul[Int(index)]
            }
        }
        return result
    }
}
