import UIKit
import ComposableArchitecture

@Reducer
public struct OpenSourceListFeature {
    @ObservableState
    public struct State: Equatable {
        public let opensources: [Opensource] = Opensource.items
        
        public init() { }
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case linkTapped(_ link: String)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .linkTapped(link):
                guard let url = URL(string: link) else { return .none }
                UIApplication.shared.open(url)
                return .none
            }
        }
    }
    
    public init() { }
}

public struct Opensource: Equatable, Identifiable {
    public var id: String { name }
    public let name: String
    public let link: String
    
}

extension Opensource {
    public static let items: [Opensource] = [
        Opensource(name: "Composable Architecture", link: "https://github.com/pointfreeco/swift-composable-architecture/tree/main"),
        Opensource(name: "KuringPackage", link: "https://github.com/ku-ring/ios-app"),
        Opensource(name: "The Satellite", link: "https://github.com/ku-ring/the-satellite"),
        
    ]
    
}
