//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

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
        Reduce { _, action in
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
