//
//  ReportCommentView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/2/25.
//

import SwiftUI
import ColorSet
import NoticeFeatures
import ComposableArchitecture

/// 댓글 신고 화면
/// ```swift
/// ReportCommentView(store: store)
/// ```
///  - Parameters:
///    - store: NoticeReportCommentFeature 리듀서
public struct ReportCommentView: View {
    @Bindable var store: StoreOf<NoticeReportCommentFeature>
    @Environment(\.dismiss) var dismiss
    
    @State private var reportText: String = ""
    @FocusState private var isTextFieldFocused: Bool?
    
    /// 최대 글자수
    private let maxLength = 256
    /// 최소 글자수
    private let minLength = 4
    
    private var isEmpty: Bool {
        reportText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isValid: Bool {
        reportText.trimmingCharacters(in: .whitespacesAndNewlines).count >= minLength
    }
    
    public init(store: StoreOf<NoticeReportCommentFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Image("report_icon", bundle: .module)
                        .resizable()
                        .frame(width: 100, height: 100)

                    Text("해당 댓글의\n신고 사유를 작성해주세요.")
                        .font(.system(size: 16, weight: .medium))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 12)
                        
                    textFieldView
                        .frame(height: 268)
                        .padding(.top, 38)
                }
                .padding(20)
            }
            .background(Color.Kuring.bg)
            .navigationTitle("신고하기")
            .onTapGesture {
                isTextFieldFocused = nil
            }
            
            submitButton
                .padding([.horizontal, .bottom], 20)
        }
        .background(Color.Kuring.bg)
    }
    
    private var textFieldView: some View {
        ZStack(alignment: .bottomTrailing) {
            TextEditor(text: $reportText)
                .focused($isTextFieldFocused, equals: true)
                .font(.system(size: 15))
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.Kuring.bg)
                        .stroke(Color.Kuring.gray200, lineWidth: 1)
                )
                .overlay(alignment: .topLeading) {
                    if reportText.isEmpty {
                        Text("최소 4글자 이상 작성해 주세요")
                            .font(.system(size: 16))
                            .padding(.horizontal, 20)
                            .padding(.top, 18)
                            .foregroundStyle(Color.Kuring.caption1)
                            .allowsHitTesting(false)
                    }
                }
                .onChange(of: reportText) { _, newValue in
                    if newValue.count > maxLength {
                        reportText = String(newValue.prefix(maxLength))
                    }
                }
            
            if !isEmpty {
                Group {
                    if !isValid {
                        Text("4글자 이상 입력해 주세요")
                            .foregroundStyle(Color.Kuring.warning)
                    } else {
                        Text("\(reportText.count)/\(maxLength)")
                            .foregroundStyle(Color.Kuring.primary)
                    }
                }
                .font(.system(size: 14))
                .padding(.trailing, 14)
                .padding(.bottom, 10)
            }
        }
    }

    private var submitButton: some View {
        Button {
            store.send(.reportComment)
        } label: {
            Text("신고하기")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isValid ? Color.Kuring.bg : Color.Kuring.caption1)
                .frame(height: 56)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    Capsule()
                        .fill(isValid ? Color.Kuring.primary : Color.Kuring.gray200)
                )
        }
        .disabled(!isValid)
    }
}

#Preview {
    @Previewable @State var store: StoreOf<NoticeReportCommentFeature> = .init(
        initialState: NoticeReportCommentFeature.State(commentId: 1, content: "테스트용임다")) {
            NoticeReportCommentFeature()
        }
    ReportCommentView(store: store)
}
