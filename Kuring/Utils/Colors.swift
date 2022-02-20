//
//  Colors.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2022/01/21.
//

import UIKit

struct ColorSet {
    static var green: UIColor { General.green }
    static var secondaryGreen: UIColor { General.secondaryGreen }
    static var pink: UIColor { General.pink }
    static var gray: UIColor { General.gray }
    static var secondaryGray: UIColor { General.secondaryGray }
    
    struct General {
        static let green = UIColor(named: "ColorSet.green") ?? UIColor.green
        static let secondaryGreen = UIColor(named: "ColorSet.secondaryGreen") ?? UIColor.green.withAlphaComponent(0.5)
        static let pink = UIColor(named: "ColorSet.pink") ?? UIColor.systemPink
        static let gray = UIColor(named: "ColorSet.gray") ?? UIColor.gray
        static let secondaryGray = UIColor(named: "ColorSet.secondaryGray") ?? UIColor.lightGray
    }
    
    struct Label {
        static let primary = UIColor(named: "ColorSet.Label.primary") ?? UIColor.label
        static let secondary = UIColor(named: "ColorSet.Label.secondary") ?? UIColor.secondaryLabel
        static let tertiary = UIColor(named: "ColorSet.Label.tertiary") ?? UIColor.tertiaryLabel
        static let green = UIColor(named: "ColorSet.Label.green") ?? UIColor.green
    }
    
    struct Background {
        static let primary = UIColor(named: "ColorSet.Background.primary") ?? UIColor.secondarySystemGroupedBackground
    }
}

