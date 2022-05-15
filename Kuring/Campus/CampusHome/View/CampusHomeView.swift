//
//  CampusHomeView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/08.
//

import SwiftUI
import KuringCommons
import AuthenticationServices

struct CampusHomeView: View {
    @StateObject var viewModel = CampusViewModel()
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.currentState {
                case is UsernameRequestState:
                    CampusUsernameView(viewModel: viewModel)
                default:
                    CampusStartView(viewModel: viewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("쿠링캠퍼스")
                        .font(.title3.bold())
                        .foregroundColor(ColorSet.Label.primary.color)
                }
            }
            .tint(ColorSet.green.color)
        }
        .fullScreenCover(isPresented: $viewModel.onChat) {
            if let chatStartedState = viewModel.currentState as? ChatStartedState {
                ChatView(channel: chatStartedState.channel)
            }
        }
    }
}

struct CampusSignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CampusHomeView(viewModel: .init())
            
            CampusHomeView(viewModel: .init())
                .preferredColorScheme(.dark)
        }
    }
}
