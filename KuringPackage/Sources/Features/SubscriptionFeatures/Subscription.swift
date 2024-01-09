import Models
import KuringLink
import ComposableArchitecture

@Reducer
public struct SubscriptionFeature {
    @ObservableState
    public struct State: Equatable {
        public var subscriptionType: SubscriptionType = .university
        
        /// 대학 공지 리스트
        public let univNoticeTypes: IdentifiedArrayOf<NoticeProvider> = IdentifiedArray(uniqueElements: NoticeProvider.univNoticeTypes)
        /// 대학 공지 리스트 중 내가 구독한 공지
        public var selectedUnivNoticeType: IdentifiedArrayOf<NoticeProvider> = []
        
        /// 내가 추가한 공지 리스트
        public var myDepartments: IdentifiedArrayOf<NoticeProvider> = IdentifiedArray(uniqueElements: NoticeProvider.departments)
        /// 내가 추가한 공지 리스트 중 지금 선택한 학과
        public var selectedDepartment: IdentifiedArrayOf<NoticeProvider> = []
        
        public var isWaitingResponse: Bool = false
        
        public enum SubscriptionType: Equatable {
            case university
            case department
        }
        
        public init(
            subscriptionType: SubscriptionType = .university,
            selectedUnivNoticeType: IdentifiedArrayOf<NoticeProvider> = [],
            myDepartments: IdentifiedArrayOf<NoticeProvider> = IdentifiedArray(uniqueElements: NoticeProvider.departments),
            selectedDepartment: IdentifiedArrayOf<NoticeProvider> = [],
            isWaitingResponse: Bool = false
        ) {
            self.subscriptionType = subscriptionType
            self.selectedUnivNoticeType = selectedUnivNoticeType
            self.myDepartments = myDepartments
            self.selectedDepartment = selectedDepartment
            self.isWaitingResponse = isWaitingResponse
        }
    }
    
    public enum Action: Equatable {
        /// 일반 / 학과 카테고리 세그먼트 선택
        case segmentSelected(State.SubscriptionType)
        /// 일반 공지 카테고리 중 하나 선택
        case univNoticeTypeSelected(NoticeProvider)
        /// 학과 공지 카테고리 중 하나 선택
        case departmentSelected(NoticeProvider)
        /// 완료 버튼 탭
        case confirmButtonTapped
        /// 구독 성공 여부 (API 응답)
        case subscriptionResponse(Bool)
    }
    
    @Dependency(\.kuringLink) var kuringLink
    @Dependency(\.dismiss) var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .segmentSelected(let subscriptionType):
                state.subscriptionType = subscriptionType
                return .none
                
            case .univNoticeTypeSelected(let noticeProvider):
                if state.selectedUnivNoticeType.contains(noticeProvider) {
                    state.selectedUnivNoticeType.remove(id: noticeProvider.id)
                } else {
                    state.selectedUnivNoticeType.append(noticeProvider)
                }
                return .none
                
            case .departmentSelected(let department):
                if state.selectedDepartment.contains(department) {
                    state.selectedDepartment.remove(id: department.id)
                } else {
                    state.selectedDepartment.append(department)
                }
                return .none
                
            // TODO: API & NoticeListFeature 쪽에 Delegate 방식 처리 체크
            case .confirmButtonTapped:
                state.isWaitingResponse = true
                return .run { [state] send in
                    let typeNames = state.selectedUnivNoticeType.compactMap { $0.name }
                    let hostPrefixes = state.selectedDepartment.compactMap { $0.hostPrefix }
                    async let univSubscription = kuringLink.subscribeUnivNotices(typeNames)
                    async let deptSubscription = kuringLink.subscribeDepartments(hostPrefixes)
                    
                    do {
                        let results = try await [univSubscription, deptSubscription]
                        await send(.subscriptionResponse(!results.contains(false)))
                    } catch {
                        await send(.subscriptionResponse(false))
                    }
                }
                
            case let .subscriptionResponse(isSucceeded):
                // TODO: UX 어떻게 할지 디자이너 분들과 논의 해야함 (알림을 띄울지 말지)
                print(isSucceeded ? "구독 성공~" : "구독 실패")
                state.isWaitingResponse = false
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
    
    public init() { }
}
