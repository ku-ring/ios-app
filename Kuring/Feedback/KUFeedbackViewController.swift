//
//  KUFeedbackViewController.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/29.
//

import UIKit
import KuringSDK

class KUFeedbackViewController: UIViewController {
    @IBOutlet weak var textViewBackgroundView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textLimitLabel: UILabel!
    @IBOutlet weak var sendButon: UIButton!
    
    let placeholder = "피드백을 남겨주세요."
    var isTextViewEmpty: Bool { textView.text == placeholder }
    let textLimit: (min: Int, max: Int) = (min: 4, max: 256)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = placeholder
        textView.textColor = ColorSet.Label.tertiary
        textView.delegate = self
        
        textViewBackgroundView.backgroundColor = .clear
        textViewBackgroundView.layer.cornerRadius = 12
        textViewBackgroundView.layer.borderWidth = 1
        textViewBackgroundView.layer.borderColor = ColorSet.green.cgColor
        
        textLimitLabel.text = "\(textLimit.min)글자 이상 입력해주세요"
        
        sendButon.layer.cornerRadius = sendButon.frame.height / 2
        sendButon.layer.masksToBounds = true
        updateButtonState(enabled: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
        textView.resignFirstResponder()
    }
    
    @IBAction func didTapSend() {
        guard !textView.text.isEmpty, textView.text != placeholder else { return }
        guard textView.text.count >= textLimit.min else { return }
        guard textView.text.count <= textLimit.max else { return }
        
        Kuring.sendFeedback(textView.text) { [weak self] result in
            guard let self = self else { return }
            // 전송 완료 시 결과와 상관 없이 `textView`를 활성화 시킵니다.
            self.textView.text = ""
            self.textView.isEditable = false
            
            self.dismiss(animated: true, completion: nil)
            switch result {
            case .success: break
            case .failure(let error): Logger.debug(error.localizedDescription)
            }
        }
        // 피드백 전송 시 `textView` 와 `sendButton` 을 비활성화 시킵니다.
        textView.endEditing(true)
        textView.isEditable = false
        updateButtonState(enabled: false)
    }
    
    func updateButtonState(enabled: Bool) {
        sendButon.isEnabled = enabled
        sendButon.alpha = enabled ? 1.0 : 0.5
    }
}

extension KUFeedbackViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isTextViewEmpty {
            textView.text = ""
            textView.textColor = ColorSet.Label.primary
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = ColorSet.Label.tertiary
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count < textLimit.min {
            updateButtonState(enabled: false)
            textLimitLabel.text = "\(textLimit.min)글자 이상 입력해주세요"
        } else {
            updateButtonState(enabled: true)
            textLimitLabel.text = "글자수: \(textView.text.count) / \(textLimit.max)"
        }
        if textView.text.count > textLimit.max {
            updateButtonState(enabled: false)
            textLimitLabel.textColor = ColorSet.pink
        } else {
            textLimitLabel.textColor = ColorSet.Label.secondary
        }
    }
}
