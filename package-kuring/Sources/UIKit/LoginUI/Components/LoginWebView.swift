//
//  LoginWebView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/17/25.
//

import CommonUI
import SwiftUI
import LoginFeatures
import ComposableArchitecture

public struct LoginWebView: View {
    @Bindable public var store: StoreOf<WebViewFeature>

    public var body: some View {
        WebView(urlString: store.url ?? KumailLink.url.rawValue)
    }

    public init(store: StoreOf<WebViewFeature>) {
        self.store = store
    }
}
