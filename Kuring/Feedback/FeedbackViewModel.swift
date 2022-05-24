//
//  FeedbackViewModel.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/03/18.
//

import SwiftUI
import KuringSDK
import KuringCommons

class FeedbackViewModel: ObservableObject {
    @Published var feedback: String {
        didSet { updateStates() }
    }
    @Published private(set) var textLimitGuide: String
    @Published private(set) var isSendable: Bool = false
    @Published private(set) var isOverTextLimit: Bool = false
    @Published private(set) var textEditorColor: Color = ColorSet.Label.tertiary.color
    @Published private(set) var textLimitColor: Color = ColorSet.Label.secondary.color
    
    let placeholder = "피드백을 남겨주세요"
    let textLimit: (min: Int, max: Int) = (min: 5, max: 256)
    
    init() {
        feedback = placeholder
        textLimitGuide = "\(textLimit.min)글자 이상 입력해주세요"
    }
    
    func send(onComplete: @escaping () -> Void) {
        guard !feedback.isEmpty, feedback != placeholder else { return }
        guard isSendable else { return }
        Kuring.sendFeedback(feedback) { [weak self] result in
            guard let self = self else { return }
            // 전송 완료 시 결과와 상관 없이 `feedback`를 활성화 시킵니다.
            self.feedback = self.placeholder
            
            switch result {
            case .success: break
            case .failure(let error): Logger.debug(error.localizedDescription)
            }
            onComplete()
        }
        isSendable = false
    }
    
    private func updateStates() {
        isSendable = feedback != placeholder
            && feedback.count >= textLimit.min
            && feedback.count <= textLimit.max
        textLimitGuide = feedback.count < textLimit.min || feedback == placeholder
            ? "\(textLimit.min)글자 이상 입력해주세요"
            : "글자수: \(feedback.count) / \(textLimit.max)"
        isOverTextLimit = feedback.count > textLimit.max
        textLimitColor = isOverTextLimit
            ? ColorSet.pink.color
            : ColorSet.Label.secondary.color
    }
    
    func endEditing() {
        if feedback.isEmpty {
            feedback = placeholder
            textEditorColor = ColorSet.Label.tertiary.color
        }
    }
    
    func startEditing() {
        if feedback == placeholder {
            feedback = ""
            textEditorColor = ColorSet.Label.primary.color
        }
    }
}
