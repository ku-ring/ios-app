//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import ComposableArchitecture

extension LabAppFeature {
    @Reducer(state: .equatable, action: .equatable)
    public enum Path {
        /// - Important: 테스트를 위한 케이스 이므로 삭제하지 말 것
        case betaA(BetaADetailFeature)
        case appIcon(AppIconDetailFeature)
        case userDefaults(UserDefaultsDetailFeature)
    }
}
