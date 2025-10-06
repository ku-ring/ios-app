//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import NoticeFeatures
import ComposableArchitecture

extension BookmarkAppFeature {
    @Reducer
    public struct Path {
        @ObservableState // TODO: 필요??
        public enum State: Equatable {
            case detail(NoticeDetailFeature.State)
            case reportComment(NoticeReportCommentFeature.State)
        }

        public enum Action {
            case detail(NoticeDetailFeature.Action)
            case reportComment(NoticeReportCommentFeature.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.detail, action: \.detail) {
                NoticeDetailFeature()
            }
            Scope(state: \.reportComment, action: \.reportComment) {
                NoticeReportCommentFeature()
            }
        }
    }
}
