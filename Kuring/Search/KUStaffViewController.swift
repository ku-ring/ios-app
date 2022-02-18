//
//  KUStaffViewController.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import MessageUI
import KuringSDK

class KUStaffViewController: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deptLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var labLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    
    var staff: Staff!
    
    override func viewDidLoad() {
        nameLabel.text = staff.name
        deptLabel.text = "\(staff.deptName) · \(staff.collegeName)"
        emailLabel.text = "✉️ " + staff.email
        phoneLabel.text = "📞 " + staff.phoneNumber
        labLabel.text = "📍 " + staff.lab
        majorLabel.text = "📖 " + staff.major
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1 else { return } // 0: 주요정보, 1: 연락처, 2: 기타정보
        switch indexPath.row {
            case 0: // email
                sendEmail()
            case 1: // phone
                showAskingCallActionSheet()
            default: return
        }
    }
    
    /// `staff.phoneNumber`를 실제 전화가능한 문자열로 가공한 뒤 전화를 겁니다.
    private func makeCall() {
//        let validPhoneNumber = staff.phoneNumber.replacingOccurrences(of: CharacterSet.decimalDigits.inverted, with: "")
        let validPhoneNumber = staff.phoneNumber.replacingOccurrences(of: "-", with: "") // - 가 아닌 char도 삭제
        guard let phoneURL = URL(string: "tel://" + validPhoneNumber) else { return }
        UIApplication.shared.open(phoneURL)
    }
    
    /// 메일을 보낼 수 있는지 여부를 체크하고 `staff.email`를 이메일 주소 값으로 하는 메일창을 띄웁니다. 보낼 수 없는 상태면 에러창을 띄웁니다.
    private func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            self.showSendMailErrorAlert()
            return
        }
        let compseVC = MFMailComposeViewController()
        compseVC.mailComposeDelegate = self
        compseVC.setToRecipients([staff.email])
        self.present(compseVC, animated: true, completion: nil)
    }
    
    /// 메일 계정이 세팅되지 않았거나 기타 에러가 있어서 메일을 전송할 수 없을 경우 호출 됩니다.
    private func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "메일 전송 실패", message: "이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 전화번호를 눌렀을 때, 실수로 눌렀을 경우를 대비하여 **action sheet**를 보여줍니다.
    private func showAskingCallActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let callAction = UIAlertAction(title: "\(staff.phoneNumber)로 전화걸기", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.makeCall()
        }
        let cancelAction = UIAlertAction(title: "아이KU! 잘못 눌렀어요.", style: .cancel) // 개드립 금지!
        actionSheet.addAction(callAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension KUStaffViewController: MFMailComposeViewControllerDelegate {
    /// 메일 전송이 완료되었을 때 호출 되는 이벤트 입니다.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
