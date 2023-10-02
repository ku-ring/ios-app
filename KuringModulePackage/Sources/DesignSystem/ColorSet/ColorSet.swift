//
//  ColorSet.swift
//
//
//  Created by 🏝️ GeonWoo Lee on 10/2/23.
//

/**
 MIT License

 Copyright (c) 2022 Kuring

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

/// 쿠링 프로젝트에 사용되는 색상 세트 입니다.
public struct ColorSet {
    
    /// 쿠링 초록색 입니다. 버튼의 배경색상, 테두리 색상 등에 사용되며 다른 초록색 계열과 함께 사용되지 않도록 해야합니다.
    public static let green = UIColor(resource: .colorSetGreen)
    
    /// 라벨, 텍스트에 사용하는 것을 목적으로 하는 색상입니다.
    public struct Label {
        /// 쿠링의 일반 글자색입니다. 기본은 검정색이며, 다크모드는 흰색입니다.
        public static let primary = UIColor(resource: .colorSetLabelPrimary)
        
        /// 쿠링의 2순위 글자색입니다. 기본은 진한 회색이며, 다크모드는 연한 흰색입니다.
        public static let secondary = UIColor(resource: .colorSetLabelSecondary)

        /// 쿠링 텍스트용 초록색입니다. `ColorSet.green` 과 동일한 초록색입니다.
        public static let green = UIColor(resource: .colorSetLabelGreen)
        
        /// 쿠링 텍스트용 진한 회색입니다.
        public static let gray = UIColor(resource: .colorSetLabelGray)
        
        /// 쿠링 텍스트용 약간 진한 회색입니다.
        public static let secondaryGray = UIColor(resource: .colorSetLabelGray)
    }
    
    /// 배경에 사용하는 것을 목적으로 하는 색상입니다.
    public struct Background {
        /// 쿠링 기본 배경색입니다. 기본은 검은색, 다크모드는 매우 짙은 회색입니다.
        public static let primary = UIColor(resource: .colorSetBackgroundPrimary)
        
        /// 쿠링 배경용 초록색입니다. `ColorSet.green` 보다 연한 초록색입니다.
        /// 글자색으로 `Label.green` 을 사용하는 컴포넌트의 배경색으로 사용합니다.
        public static let green = UIColor(resource: .colorSetGreen)
        
        /// 쿠링맵 전용 배경색으로 양피지 같은 연한 노란색입니다. (다크모드는 짙은 청록색)
        public static let kuringMap = UIColor(resource: .colorSetKuringMapBackground)
    }
}

import SwiftUI

extension UIColor {
    /// `SwiftUI.Color` 타입의 오브젝트를 리턴합니다.
    public var color: Color { return Color(uiColor: self) }
}
