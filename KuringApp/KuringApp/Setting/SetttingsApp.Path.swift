//
//  SetttingsApp.Path.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/10/06.
//

import SwiftUI
import ComposableArchitecture

extension SettingsAppFeature {
    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable {
            case appIconSelector(AppIconSelectorFeature.State)
            case openSourceList(OpenSourceFeature.State)
        }
        
        enum Action {
            case appIconSelector(AppIconSelectorFeature.Action)
            case openSourceList(OpenSourceFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.appIconSelector, action: \.appIconSelector) {
                AppIconSelectorFeature()
            }
            Scope(state: \.openSourceList, action: \.openSourceList) {
                OpenSourceFeature()
            }
        }
    }
}
