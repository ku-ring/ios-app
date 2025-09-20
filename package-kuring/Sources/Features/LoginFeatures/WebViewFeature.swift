//
//  WebViewFeature.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/17/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct WebViewFeature {
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
