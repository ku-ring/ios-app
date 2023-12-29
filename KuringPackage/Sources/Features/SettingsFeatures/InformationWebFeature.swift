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
        Reduce { state, action in
            return .none
        }
    }
    
    public init() { }
}
