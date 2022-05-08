//
//  CampusStartView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons
import AuthenticationServices

struct CampusStartView: View {
    @ObservedObject var viewModel: CampusViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 64) {
            Spacer()
            
            Image("campus.man.sitdown")
                .padding(.horizontal, 64)
                .clipped()
            
            Text("쿠링 청심대에서 다같이 모여 메세지를 보내세요")
            
            switch viewModel.currentState{
            case is InitialState, is ConnectingState, is ChannelRetrievalState:
                LottieView(filename: StringSet.Lottie.loading)
            case is ConnectedState:
                Button(action: viewModel.startChat) {
                    RoundedRectangle(cornerRadius: 26)
                        .frame(width: 232, height: 52)
                        .foregroundColor(ColorSet.green.color)
                        .overlay {
                            Text("시작하기")
                                .foregroundColor(ColorSet.Background.primary.color)
                        }
                        .padding(.bottom, 64)
                }
            default:
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
            }
        }
    }
}

struct CampusStartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                CampusStartView(viewModel: .init())
                    .navigationTitle(Text("쿠링캠퍼스"))
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
//        .previewLayout(.sizeThatFits)
    }
}

