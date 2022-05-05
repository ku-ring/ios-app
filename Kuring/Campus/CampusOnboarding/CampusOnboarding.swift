//
//  CampusOnboarding.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons

struct CampusOnboarding: View {
    @ObservedObject var viewModel: CampusOnboardingViewModel
    
    var body: some View {
        NavigationView {
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
                    Button(action: viewModel.dismiss) {
                        Image(systemName: "xmark")
                            .foregroundColor(ColorSet.green.color)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("쿠링캠퍼스")
                        .font(.title3.bold())
                        .foregroundColor(ColorSet.Label.primary.color)
                }
            }
            .tint(ColorSet.green.color)
        }
    }
}

struct CampusActivateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CampusOnboarding(viewModel: .init())
            
            CampusOnboarding(viewModel: .init())
                .preferredColorScheme(.dark)
        }
//        .previewLayout(.sizeThatFits)
    }
}

