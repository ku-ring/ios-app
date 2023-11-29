//
//  OpenSourceView.swift
//  KuringApp
//
//  Created by 박성수 on 11/30/23.
//

import SwiftUI
import ComposableArchitecture

struct OpenSourceFeature: Reducer {
    struct State: Equatable {
        
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}

struct OpenSourceView: View {
    let store: StoreOf<OpenSourceFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List(Opensource.items, id: \.self) { item in
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    Button(action: {
                        UIApplication.shared.open(URL(string: item.link)!)
                    }) {
                        Text(item.link)
                    }
                }
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

struct Opensource: Hashable {
    var name: String
    var link: String
    
}

extension Opensource {
    static let items: [Opensource] = [
        Opensource(name: "TCA - The Composable Architecture", link: "https://github.com/pointfreeco/swift-composable-architecture/tree/main"),
        Opensource(name: "Lottie", link: "https://github.com/airbnb/lottie-ios"),
        Opensource(name: "KuringCommons", link: "https://github.com/KU-Stacks/kuring-ios-commons"),
        Opensource(name: "The Satellite", link: "https://github.com/ku-ring/the-satellite"),
        
    ]
    
}
