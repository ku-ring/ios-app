//
//  KUSearchViewController.UITextField.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit

extension KUSearchViewController: UITextFieldDelegate {
    /// `textField.text` 가 유효한 값이면 서쳐를 통해 실시간 검색 결과를 요청합니다.
    @objc func textFieldDidChange(_ sender: Any?) {
        guard let text = self.textField.text else {
            resetResult()
            return
        }
        searcher?.search(text, forType: currentType)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// 여기서 초기화 된 변수들은 didSet 에서 적절하게 `tableView.reloadData()` 를 호출합니다
    func resetResult() {
        staffResult = []
        noticeResult = []
    }
}
