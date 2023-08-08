//
//  UIColor+.swift
//  DesignSystem
//
//  Created by 🏝️ GeonWoo Lee on 2023/08/09.
//  Copyright © 2023 Team.Kuring. All rights reserved.
//

import SwiftUI

extension UIColor {
    /// `SwiftUI.Color` 타입의 오브젝트를 리턴합니다.
    public var color: Color {
        Color(uiColor: self)
    }
}
