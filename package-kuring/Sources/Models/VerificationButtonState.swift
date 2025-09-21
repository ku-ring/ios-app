//
//  VerificationButtonState.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/16/25.
//

import SwiftUI
import ColorSet

public enum VerificationButtonState {
    case disabled
    case send
    case resend
    
    public var buttonText: String {
        switch self {
        case .disabled, .send:
            return "인증번호"
        case .resend:
            return "재전송"
        }
    }
    
    public var isEnabled: Bool {
        switch self {
        case .disabled:
            return false
        case .send, .resend:
            return true
        }
    }
    
    public var textColor: Color {
        switch self {
        case .disabled:
            return Color.Kuring.caption1
        case .send, .resend:
            return Color.Kuring.primary
        }
    }
    
    public var backgroundColor: Color {
        switch self {
        case .disabled:
            return Color.Kuring.gray100
        case .send, .resend:
            return Color.Kuring.primarySelected
        }
    }
    
    public var borderColor: Color {
        switch self {
        case .disabled:
            return Color.Kuring.caption2
        case .send, .resend:
            return Color.Kuring.primary
        }
    }
}
