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
        }
        
        enum Action {
            case appIconSelector(AppIconSelectorFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.appIconSelector, action: /Action.appIconSelector) {
                AppIconSelectorFeature()
            }
        }
    }
}
