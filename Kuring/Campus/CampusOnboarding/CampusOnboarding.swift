//
//  CampusOnboarding.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons

public struct CampusOnboarding: View {
    @StateObject private var viewModel = CampusOnboardingViewModel()
    
    public var body: some View {
        ZStack {
            CampusStartView(viewModel: viewModel)
                .offset(
                    x: viewModel.activateState == .initial
                    ? 0
                    : -UIScreen.main.bounds.width
                )
            
            CampusUsernameView(viewModel: viewModel)
                .offset(
                    x: viewModel.activateState == .initial
                    ? UIScreen.main.bounds.width
                    : 0
                )
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {}) {
                    Image(systemName: "xmark")
                        .foregroundColor(ColorSet.green.color)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("쿠링캠퍼스")
            }
        }
    }
    
    public init() { }
}

struct CampusActivateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CampusOnboarding()
            
            CampusOnboarding()
                .preferredColorScheme(.dark)
        }
//        .previewLayout(.sizeThatFits)
    }
}

