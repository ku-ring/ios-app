import Models
import ComposableArchitecture

@Reducer
public struct StaffDetailFeature {
    @ObservableState
    public struct State: Equatable {
        public let staff: Staff
        
        public init(staff: Staff) {
            self.staff = staff
        }
    }
    
    public enum Action {
        case emailAddressTapped
        case phoneNumberTapped
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .emailAddressTapped:
                return .none
                
            case .phoneNumberTapped:
                return .none
            }
        }
    }
    
    public init() { }
}
