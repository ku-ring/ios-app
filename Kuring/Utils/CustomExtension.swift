//
//  CustomFunction.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2021/12/01.
//

import UIKit
import SnapKit

// MARK: UIView
extension UIView {
    
    /// SnapKit 에서 쓰기 위한 Safe Area 속성
    var safeArea : ConstraintLayoutGuideDSL {
        return safeAreaLayoutGuide.snp
    }
    
    func addSubViews(_ subViews: [UIView]) {
        subViews.forEach { subView in
            addSubview(subView)
        }
    }
    
    func setWhiteBackground() {
        backgroundColor = .white
    }
}

extension UIViewController {
    /// Modality 방식에서 전체 화면으로 보여준다.
    func presentFullScreen(_ viewControllerToPresent: UIViewController) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        viewControllerToPresent.modalTransitionStyle = .crossDissolve
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}

extension String {
    var isToday: Bool {
        // TODO: Implementation
        true
    }
}


extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}


extension DateFormatter {
    static let `default`: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        return formatter
    }()
}


extension Date {
    // TODO: kuring sdk 에도 같은거 있음
    func isSameDay(as otherDate: Date) -> Bool {
        let baseDate = self
        let otherDate = otherDate
        
        let baseDateComponents = Calendar.current.dateComponents(
            [.day, .month, .year],
            from: baseDate
        )
        let otherDateComponents = Calendar.current.dateComponents(
            [.day, .month, .year],
            from: otherDate
        )
        
        if baseDateComponents.year == otherDateComponents.year,
           baseDateComponents.month == otherDateComponents.month,
           baseDateComponents.day == otherDateComponents.day {
            return true
        }
        else {
            return false
        }
    }
}

extension UIButton {
    func setSelectedButton() {
        setTitleColor(#colorLiteral(red: 0.01166580617, green: 0.4252832532, blue: 0.2513835132, alpha: 1), for: .normal)
        backgroundColor = #colorLiteral(red: 0.7755471468, green: 0.9234577417, blue: 0.8548737168, alpha: 1)
    }
    
    func setUnselectedButton() {
        setTitleColor(#colorLiteral(red: 0.3999999464, green: 0.3999999464, blue: 0.3999999464, alpha: 1), for: .normal)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    
//    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        let margin: CGFloat = 20
//        let hitArea = self.bounds.insetBy(dx: -margin, dy: -margin)
//        return hitArea.contains(point)
//    }
}
