//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct InformationWebFeature {
    @ObservableState
    public struct State: Equatable {
        public var url: String?

        public init(url: String? = nil) {
            self.url = url
        }
    }

    public enum Action: Equatable { }

    public var body: some ReducerOf<Self> {
        Reduce { _, _ in
            .none
        }
    }

    public init() { }
}
