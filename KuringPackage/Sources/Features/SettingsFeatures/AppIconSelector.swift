import Caches
import Foundation
import ComposableArchitecture

@Reducer
public struct AppIconSelectorFeature {
    @ObservableState
    public struct State: Equatable {
        public var appIcons: IdentifiedArrayOf<KuringIcon> = IdentifiedArray(uniqueElements: KuringIcon.allCases)
        public var selectedIcon: KuringIcon?
        public var currentIcon: KuringIcon
        
        public init(
            appIcons: IdentifiedArrayOf<KuringIcon> = IdentifiedArray(uniqueElements: KuringIcon.allCases),
            selectedIcon: KuringIcon? = nil
        ) {
            @Dependency(\.appIcons) var appIconClient
            self.appIcons = appIcons
            self.selectedIcon = selectedIcon ?? appIconClient.currentAppIcon
            self.currentIcon = appIconClient.currentAppIcon
        }
    }
    
    public enum Action: Equatable {
        /// 앱 아이콘 선택
        case appIconSelected(KuringIcon)
        /// 앱 아이콘 저장하기 버튼
        case saveButtonTapped
        
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case completeAppIconChange
        }
    }
    
    @Dependency(\.appIcons) public var appIcons
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .appIconSelected(icon):
                state.selectedIcon = icon
                return .none
                
            case .saveButtonTapped:
                return .run { [selectedIcon = state.selectedIcon] send in
                    guard let selectedIcon else { return }
                    await appIcons.changeTo(selectedIcon)
                    await send(.delegate(.completeAppIconChange))
                }
                
            case .delegate:
                return .none
            }
        }
    }
    
    public init() { }
}
