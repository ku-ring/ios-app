//
//  OpenSourceView.swift
//  KuringApp
//
//  Created by 박성수 on 11/30/23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct OpenSourceFeature {
    @ObservableState
    struct State: Equatable {
        let opensources: [Opensource] = Opensource.items
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        
        case linkTapped(_ link: String)
    }
    
    var body: some ReducerOf<Self> {
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
}

struct OpenSourceView: View {
    @Bindable var store: StoreOf<OpenSourceFeature>
    
    var body: some View {
        List(store.opensources) { opensource in
            VStack(alignment: .leading) {
                Text(opensource.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                Button {
                    store.send(.linkTapped(opensource.link))
                } label: {
                    Text(opensource.link)
                }
                .tint(Color.accentColor)
            }
        }
    }
}

#Preview {
    OpenSourceView(
        store: Store(
            initialState: OpenSourceFeature.State(),
            reducer: { OpenSourceFeature() }
        )
    )
}

struct Opensource: Equatable, Identifiable {
    var id: String { name }
    let name: String
    let link: String
    
}

extension Opensource {
    static let items: [Opensource] = [
        Opensource(name: "Composable Architecture", link: "https://github.com/pointfreeco/swift-composable-architecture/tree/main"),
        Opensource(name: "KuringPackage", link: "https://github.com/ku-ring/ios-app"),
        Opensource(name: "The Satellite", link: "https://github.com/ku-ring/the-satellite"),
        
    ]
    
}
