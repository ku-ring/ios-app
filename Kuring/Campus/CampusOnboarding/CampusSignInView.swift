//
//  CampusSignInView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/08.
//

import SwiftUI
import KuringCommons
import AuthenticationServices

struct CampusSignInView: View {
    @ObservedObject var viewModel: CampusViewModel
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.currentState {
                case is InitialState, is ConnectingState, is ChannelRetrievalState:
                    LottieView(filename: StringSet.Lottie.loading)
                    
                case is LoginState, is KakaoLoginState, is AppleLoginState:
                    SignInWithAppleButton(.signIn) { request in
                        viewModel.signInWithApple()
                        viewModel.configure(request)
                    } onCompletion: { result in
                        viewModel.handleResult(result)
                    }
                    .signInWithAppleButtonStyle(
                        colorScheme == .light ? .black : .white
                    )
                    .frame(height: 45)
                    .padding()
                    
                case is UsernameRequestState:
                    VStack {
                        TextField("보여질 이름을 입력하세요", text: $viewModel.pendingUsername)
                        
                        Button(action: viewModel.setupUsername) {
                            Text("Complete Sign up")
                        }
                    }
                    
                case is ConnectedState:
                    Button(action: viewModel.startChat) {
                        Text("Start Chat")
                    }
                    
                case is ChatStartedState:
                    KuringChatView()
                default:
                    EmptyView()
                }
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

struct CampusSignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CampusSignInView(viewModel: .init())
            
            CampusSignInView(viewModel: .init())
                .preferredColorScheme(.dark)
        }
    }
}
