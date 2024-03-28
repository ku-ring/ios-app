//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import Caches
import ComposableArchitecture

@Reducer
public struct DepartmentEditorFeature {
    @ObservableState
    public struct State: Equatable {
        /// 내가 선택한 학과
        public var myDepartments: IdentifiedArrayOf<NoticeProvider>
        /// 모든학과
        public var allDepartments: IdentifiedArrayOf<NoticeProvider>
        /// 검색결과
        public var searchResults: IdentifiedArrayOf<NoticeProvider>
        
        public var searchText: String
        public var focus: Field?

        public var displayOption: Display

        public enum Field {
            case search
        }

        public enum Display: Hashable {
            /// 검색 결과 보여주기
            case searchResult
            /// 내 학과 보여주기
            case myDepartment
        }

        @Presents public var alert: AlertState<Action.Alert>?

        public init(
            myDepartments: IdentifiedArrayOf<NoticeProvider> = .init(
                uniqueElements: NoticeProvider.addedDepartments
            ),
            results: IdentifiedArrayOf<NoticeProvider> = .init(
                uniqueElements: NoticeProvider.departments
            ),
            searchText: String = "",
            focus: Field? = .search,
            displayOption: Display = .myDepartment,
            alert: AlertState<Action.Alert>? = nil
        ) {
            @Dependency(\.departments) var departments
            
            self.myDepartments = IdentifiedArrayOf(uniqueElements: departments.getAll())
            self.searchResults = results
            self.allDepartments = results
            self.searchText = searchText
            self.focus = focus
            self.displayOption = displayOption
            self.alert = alert
        }
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)

        /// 학과 추가 버튼 눌렀을 때
        case addDepartmentButtonTapped(id: NoticeProvider.ID)
        /// 추가했던 학과 취소 버튼 눌렀을 때
        case cancelAdditionButtonTapped(id: NoticeProvider.ID)
        /// 내 학과 삭제 버튼 눌렀을 때
        case deleteMyDepartmentButtonTapped(id: NoticeProvider.ID)
        /// 내 학과 전체삭제 버튼 눌렀을 때
        case deleteAllMyDepartmentButtonTapped
        /// 텍스트 필드의 xmark를 눌렀을 때
        case clearTextFieldButtonTapped
        
        /// 검색 문자열 변경
        case searchQueryChanged(String)

        /// 알림 관련 액션
        case alert(PresentationAction<Alert>)
        /// 알림
        public enum Alert: Equatable {
            /// 개별 학과 추가 알림 시 추가 버튼 눌렀을 때
            case confirmAdd(department: NoticeProvider)
            /// 개별 학과 삭제 알림 시 삭제 버튼 눌렀을 때
            case confirmDelete(id: NoticeProvider.ID)
            /// 전체 삭제 알림 시 삭제 버튼 눌렀을 때
            case confirmDeleteAll
        }
        
        /// 델리게이트
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case addedDepartmentsUpdated
        }
    }

    @Dependency(\.departments) var departments
    private enum CancelID { case location }
    
    private var engine: DepartmentSearchEngine = DepartmentSearchEngine()
    
    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case let .addDepartmentButtonTapped(id: id):
                guard let department = state.searchResults.first(where: { $0.id == id }) else {
                    return .none
                }
                guard !state.myDepartments.contains(department) else {
                    return .none
                }
                state.alert = AlertState {
                    TextState("\(department.korName)를\n내 학과 목록에 추가할까요?")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("취소하기")
                    }

                    ButtonState(
                        role: .destructive,
                        action: .confirmAdd(department: department)
                    ) {
                        TextState("추가하기")
                    }
                }
                return .none

            case let .deleteMyDepartmentButtonTapped(id: id), let .cancelAdditionButtonTapped(id: id):
                guard let department = state.myDepartments.first(where: { $0.id == id }) else {
                    return .none
                }
                state.alert = AlertState {
                    TextState("\(department.korName)를\n내 학과 목록에서 삭제할까요?")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("취소하기")
                    }

                    ButtonState(role: .destructive, action: .confirmDelete(id: id)) {
                        TextState("삭제하기")
                    }
                }
                return .none

            case .deleteAllMyDepartmentButtonTapped:
                state.alert = AlertState {
                    TextState("내 학과 목록을\n모두 삭제할까요?")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("취소하기")
                    }

                    ButtonState(role: .destructive, action: .confirmDeleteAll) {
                        TextState("삭제하기")
                    }
                }
                return .none

            case .clearTextFieldButtonTapped:
                state.searchText.removeAll()
                return .none

                // MARK: Alert

            case let .alert(.presented(alertAction)):
                switch alertAction {
                case let .confirmAdd(department: department):
                    state.myDepartments.append(department)
                    departments.add(department)
                    
                case let .confirmDelete(id: id):
                    state.myDepartments.remove(id: id)
                    departments.remove(id)
                    
                case .confirmDeleteAll:
                    state.myDepartments.removeAll()
                    departments.removeAll()
                }
                NoticeProvider.addedDepartments = state.myDepartments.elements
                return .none
                
            case let .searchQueryChanged(query):
                state.searchText = query

                guard state.searchText.isEmpty else {
                    state.searchResults = engine.search(query, allDepartments: state.allDepartments)
                    
                    return .cancel(id: CancelID.location)
                }
                return .none

            case .alert(.dismiss):
                return .none
                
                // MARK: Delegate
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .onChange(of: \.myDepartments) { oldValue, newValue in
            Reduce { state, _ in
                return .send(.delegate(.addedDepartmentsUpdated))
            }
        }
    }

    public init() { }
}

struct DepartmentSearchEngine {
    /// 한글
    private var hangeul = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
    
    func search(_ text: String, allDepartments: IdentifiedArrayOf<NoticeProvider>) -> IdentifiedArrayOf<NoticeProvider> {
        var filteredDepartments: IdentifiedArrayOf<NoticeProvider>
        
        if isChosung(text) {
            let results = allDepartments.filter { department in
                department.korName.contains(text) || searchChosung(department.korName).contains(text)
            }
            
            filteredDepartments = results
        } else {
            var correctResults = allDepartments
                .filter { $0.korName.contains(text) }
                .compactMap { $0 }
                .sorted { $0.korName < $1.korName }
               
            allDepartments.forEach { department in
                var count = 0
                var textChecker = Array(repeating: 0, count: text.count)
                for alpha in department.korName {
                    for (idx, value) in text.enumerated() {
                        if value == alpha && textChecker[idx] == 0 {
                            textChecker[idx] = 1
                            count += 1
                            break
                        }
                    }
                    
                }
                if count == text.count && !correctResults.contains(department) {
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
