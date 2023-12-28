//
//  SettingsApp.Destination.swift
//  KuringApp
//
//  Created by 이재성 on 12/29/23.
//

import SwiftUI
import SubscriptionFeatures
import ComposableArchitecture

extension SettingsAppFeature {
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case feedback(FeedbackFeature.State)
            case subscription(SubscriptionAppFeature.State)
            case informationWeb(InformationWebViewFeature.State)
        }
        
        enum Action: Equatable {
            case feedback(FeedbackFeature.Action)
            case subscription(SubscriptionAppFeature.Action)
            case informationWeb(InformationWebViewFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.feedback, action: \.feedback) {
                FeedbackFeature()
            }
            Scope(state: \.subscription, action: \.subscription) {
                SubscriptionAppFeature()
            }
            Scope(state: \.informationWeb, action: \.informationWeb) {
                InformationWebViewFeature()
            }
        }
    }
}
