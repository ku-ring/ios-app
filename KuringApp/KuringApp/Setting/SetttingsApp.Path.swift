//
//  SetttingsApp.Path.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/10/06.
//

import SwiftUI
import ComposableArchitecture

extension SettingsAppFeature {
    struct Path: Reducer {
        enum State: Equatable {
            case appIconSelector(AppIconSelectorFeature.State)
            case openSourceList(OpenSourceFeature.State)
        }
        
        enum Action {
            case appIconSelector(AppIconSelectorFeature.Action)
            case openSourceList(OpenSourceFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.appIconSelector, action: /Action.appIconSelector) {
                AppIconSelectorFeature()
            }
            Scope(state: /State.openSourceList, action: /Action.openSourceList) {
                OpenSourceFeature()
            }
        }
    }
}
