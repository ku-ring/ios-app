//
//  NoticeRowFeature.swift
//
//
//  Created by Jaesung Lee on 2023/09/15.
//

import Model
import Foundation
import ComposableArchitecture

public struct NoticeRowFeature: Reducer {
    public struct State: Equatable {
        public var notice: Notice
        public var isBookmarked: Bool
    }
    
    public enum Action {
        case rowTapped
        case bookmarkButtonTapped
        
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .bookmarkButtonTapped:
                state.isBookmarked.toggle()
                return .none
                
            case .rowTapped:
                return .none
            }
        }
    }
}
