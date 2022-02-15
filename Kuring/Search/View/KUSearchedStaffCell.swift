//
//  KUSearchedStaffCell.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK

class KUSearchedStaffCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deptLabel: UILabel!
    
    var staff: Staff! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        // name label
        nameLabel.text = staff.name
        
        // major label
        deptLabel.text = "\(staff.deptName) · \(staff.collegeName)"
    }
}
