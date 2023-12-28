//
//  SetttingsApp.Path.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/10/06.
//

import SwiftUI
import SubscriptionFeatures
import ComposableArchitecture

extension SettingsAppFeature {
    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable {
            case openSourceList(OpenSourceListFeature.State)
            case appIconSelector(AppIconSelectorFeature.State)
        }
        
        enum Action: Equatable {
            case openSourceList(OpenSourceListFeature.Action)
            case appIconSelector(AppIconSelectorFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.openSourceList, action: \.openSourceList) {
                OpenSourceListFeature()
            }
            Scope(state: \.appIconSelector, action: \.appIconSelector) {
                AppIconSelectorFeature()
            }
        }
    }
}
