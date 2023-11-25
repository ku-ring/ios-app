//
//  NoticeContentView.NoDepartment.swift
//  KuringApp
//
//  Created by 이재성 on 11/24/23.
//

import Model
import SwiftUI
import ComposableArchitecture

extension NoticeContentView {
    @ViewBuilder
    func NoDepartmentView() -> some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("아직 추가된 학과가 없어요.\n관심 학과를 추가하고 공지를 확인해 보세요!")
                .font(.system(size: 15, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(.black.opacity(0.36))
            
            Spacer()
            
            NavigationLink(
                state: NoticeAppFeature.Path.State.departmentEditor(
                    // TODO: - Mock 데이터 추후 제거
                    DepartmentEditorFeature.State(
                        myDepartments: IdentifiedArray(uniqueElements: NoticeProvider.departments),
                        results: [
                            NoticeProvider(
                                name: "education",
                                hostPrefix: "edu",
                                korName: "교직과",
                                category: .학과
                            ),
                        ]
                    )
                )
            ) {
                OverlayButton("학과 추가하기")
                    .padding(.horizontal, 20)
            }
        }
    }
    
    // TODO: 디자인 시스템 분리
    /// 상단에 블러가 존재하는 버튼
    @ViewBuilder
    func OverlayButton(_ title: String) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.white)
            
            Spacer()
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 16)
        .frame(height: 50, alignment: .center)
        .background(Color.accentColor)
        .cornerRadius(100)
        .background {
            LinearGradient(
                gradient: Gradient(colors: [.white.opacity(0.1), .white]),
                startPoint: .top, endPoint: .bottom
            )
            .offset(x: 0, y: -32)
        }
    }
}
