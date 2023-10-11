//
//  KuringIcon.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/10/06.
//

import Foundation

enum KuringIcon: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case kuring_app
    case kuring_app_classic
    case kuring_app_blueprint
    case kuring_app_sketch
    
    var korValue: String {
        switch self {
        case .kuring_app: return "쿠링 기본"
        case .kuring_app_classic: return "쿠링 클래식"
        case .kuring_app_blueprint: return "쿠링 블루프린트"
        case .kuring_app_sketch: return "쿠링 스케치"
        }
    }
}

