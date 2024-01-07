import Labs
import SubscriptionFeatures
import ComposableArchitecture

extension SettingsAppFeature {
    @Reducer
    public struct Destination {
        @ObservableState
        public enum State: Equatable {
            case labs(LabAppFeature.State)
            case feedback(FeedbackFeature.State)
            case subscription(SubscriptionAppFeature.State)
            case informationWeb(InformationWebFeature.State)
        }
        
        public enum Action: Equatable {
            case labs(LabAppFeature.Action)
            case feedback(FeedbackFeature.Action)
            case subscription(SubscriptionAppFeature.Action)
            case informationWeb(InformationWebFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.labs, action: \.labs) {
                LabAppFeature()
            }
            Scope(state: \.feedback, action: \.feedback) {
                FeedbackFeature()
            }
            Scope(state: \.subscription, action: \.subscription) {
                SubscriptionAppFeature()
            }
            Scope(state: \.informationWeb, action: \.informationWeb) {
                InformationWebFeature()
            }
        }
        
        public init() { }
    }
}