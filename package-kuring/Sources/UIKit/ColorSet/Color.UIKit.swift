//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import SwiftUI

extension Color {
    public struct Kuring { }
}
/// 디자인 시스템 컬러셋
extension Color.Kuring {
    
    // MARK: - ETC
    
    public static let warning: Color = Self.color(
        light: Self.from(hex: "FF4848"),
        dark: Self.from(hex: "DE4343", alpha: 0.08)
    )
    public static let borderLine: Color = Self.color(
        light: Self.from(hex: "000000"),
        dark: Self.from(hex: "DE4343")
    )
    public static let kuringLogoText: Color = Self.color(
        light: Self.from(hex: "535B5D"),
        dark: Self.from(hex: "535B5D")
    )
    public static let bg: Color = Self.color(
        light: Self.from(hex: "FFFFFF"),
        dark: Self.from(hex: "292929")
    )
    
    // MARK: - Main
    
    public static let primarySelected: Color = Self.color(
        light: Self.from(hex: "EBF8F2"),
        dark: Self.from(hex: "454D49")
    )
    public static let primary: Color = Self.color(
        light: Self.from(hex: "3DBD80"),
        dark: Self.from(hex: "38B178")
    )
    
    // MARK: - Text
    
    public static let caption1: Color = Self.color(
        light: Self.from(hex: "868A92"),
        dark: Self.from(hex: "878787")
    )
    public static let caption2: Color = Self.color(
        light: Self.from(hex: "B1B5BD"),
        dark: Self.from(hex: "5E5E5E")
    )
    public static let body: Color = Self.color(
        light: Self.from(hex: "353C49"),
        dark: Self.from(hex: "E0E0E0")
    )
    public static let title: Color = Self.color(
        light: Self.from(hex: "333333"),
        dark: Self.from(hex: "F5F5F5")
    )
    
    // MARK: - GrayScale
    
    public static let gray400: Color = Self.color(
        light: Self.from(hex: "434343"),
        dark: Self.from(hex: "B0B0B0")
    )
    public static let gray600: Color = Self.color(
        light: Self.from(hex: "262626"),
        dark: Self.from(hex: "DFDFDF")
    )
    public static let gray100: Color = Self.color(
        light: Self.from(hex: "F2F3F5"),
        dark: Self.from(hex: "3D3D3E")
    )
    public static let gray300: Color = Self.color(
        light: Self.from(hex: "999999"),
        dark: Self.from(hex: "6B6B6B")
    )
    public static let gray200: Color = Self.color(
        light: Self.from(hex: "E5E5E5"),
        dark: Self.from(hex: "4E4E4E")
    )
    
}

// MARK: - function

extension Color.Kuring {
    
    /// SwiftUI Color
    static func color(light: UIColor, dark: UIColor) -> Color {
        return Color(Color.Kuring.uiColor(light: light, dark: dark))
    }
    
    /// UIKit Color
    static func uiColor(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitColor() {
            case .light:
                return light
            case .dark:
                return dark
            case .system:
                if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                    return dark
                } else {
                    return light
                }
            }
        }
    }
    
    /// 앱 서비스가 지원하는 컬러 타입
    enum TraitColorType: Int {
        /// 사용자지정(Light)
        case light = 0
        /// 사용자지정(Dark)
        case dark = 1
        /// 시스템 모드
        case system = 2
        
        /// 라이트 모드
        var isLight: Bool {
            switch self {
            case .light:
                return true
            case .dark:
                return false
            case .system:
                return UIScreen.main.traitCollection.userInterfaceStyle == .dark
                ? true
                : false
            }
        }
    }
    
    /// 앱이 제어받을 컬러 상태를 반환
    static func traitColor() -> TraitColorType {
        // !!!: - 현재는 별도로 사용자 지정 컬러가 없기에 system 반환
        return .system
    }
    
    /// 색상을 hexColor로 반환
    static func from(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
