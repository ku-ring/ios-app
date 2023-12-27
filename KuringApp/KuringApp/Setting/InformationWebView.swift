//
//  InformationWebView.swift
//  KuringApp
//
//  Created by 박성수 on 11/29/23.
//

import WebKit
import SwiftUI
import ComposableArchitecture

@Reducer
struct InformationWebViewFeature {
    @ObservableState
    struct State: Equatable {
        var url: String?
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

struct InformationWebView: View {
    @Bindable var store: StoreOf<InformationWebViewFeature>
    
    var body: some View {
        WebView(urlToLoad: store.url ?? InformationURL.kuringTeam.rawValue)
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
 
