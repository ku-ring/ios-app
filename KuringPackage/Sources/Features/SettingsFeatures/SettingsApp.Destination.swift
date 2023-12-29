import SubscriptionFeatures
import ComposableArchitecture

extension SettingsAppFeature {
    @Reducer
    public struct Destination {
        @ObservableState
        public enum State: Equatable {
            case feedback(FeedbackFeature.State)
            case subscription(SubscriptionAppFeature.State)
            case informationWeb(InformationWebFeature.State)
        }
        
        public enum Action: Equatable {
            case feedback(FeedbackFeature.Action)
            case subscription(SubscriptionAppFeature.Action)
            case informationWeb(InformationWebFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
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
