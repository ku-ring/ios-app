//
//  OnboardingViewModel.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/02/25.
//

import SwiftUI
import KuringSDK

class OnboardingViewModel: ObservableObject {
    @Published private(set) var onDismiss: Bool = false
    @Published private(set) var currentPage = 0
    
    func goBack() {
        if currentPage == 1 {
            withAnimation { currentPage = currentPage - 1 }
        }
    }
    
    func goNext() {
        if currentPage >= 1 { dismiss() }
        else { withAnimation { currentPage = currentPage + 1 } }
    }
    
    func dismiss() {
        onDismiss = true
    }
}
