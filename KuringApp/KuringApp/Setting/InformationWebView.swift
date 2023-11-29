//
//  InformationWebView.swift
//  KuringApp
//
//  Created by 박성수 on 11/29/23.
//

import WebKit
import SwiftUI
import ComposableArchitecture

struct InformationWebViewFeature: Reducer {
    struct State: Equatable {
        var url: String?
    }
    
    enum Action: Equatable {
        case eraseView
        
        case delegate(Delegate)
        enum Delegate: Equatable {
            case erase
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .eraseView:
                return .run { send in
                    await send(.delegate(.erase))
                }
                
            case .delegate:
                return .none
            }
        }
    }
}

struct InformationWebView: View {
    let store: StoreOf<InformationWebViewFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            WebView(urlToLoad: viewStore.url ?? InformationURL.kuringTeam.rawValue)
                .onDisappear {
                    viewStore.send(.eraseView)
                }
        }
    }
}

#Preview {
    InformationWebView(
        store: Store(
            initialState: InformationWebViewFeature.State(),
            reducer: { InformationWebViewFeature() }
        )
    )
}

 
struct WebView: UIViewRepresentable {
    var urlToLoad: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        
    }
}
 
