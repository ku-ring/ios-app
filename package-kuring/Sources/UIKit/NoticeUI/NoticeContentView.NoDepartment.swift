//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ColorSet
import NoticeFeatures
import DepartmentFeatures
import ComposableArchitecture

extension NoticeContentView {
    @ViewBuilder
    func NoDepartmentView() -> some View {
        VStack(spacing: 32) {
            Spacer()

            Text("아직 추가된 학과가 없어요.\n관심 학과를 추가하고 공지를 확인해 보세요!")
                .font(.system(size: 15, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundStyle(ColorSet.caption2)

            NavigationLink(
                state: NoticeAppFeature.Path.State.departmentEditor(
                    DepartmentEditorFeature.State()
                )
            ) {
                OverlayButton("학과 추가하기")
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
    }

    // TODO: 디자인 시스템 분리
    /// 상단에 블러가 존재하는 버튼
    @ViewBuilder
    func OverlayButton(_ title: String) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: "plus")

            Text(title)
                .font(.system(size: 16, weight: .semibold))
        }
        .foregroundStyle(Color.white)
        .padding(.horizontal, 36)
        .padding(.vertical, 16)
        .background(ColorSet.primary)
        .cornerRadius(100)
    }
}
