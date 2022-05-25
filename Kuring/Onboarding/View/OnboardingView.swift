//
//  OnboardingView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/02/23.
//

import SwiftUI
import KuringCommons

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @StateObject private var subscription = NoticeTypeSubscription()
    
    var body: some View {
        ZStack {
            OnboardingIntroView()
                .offset(x: viewModel.currentPage == 1 ? -UIScreen.main.bounds.width : 0)
            
            SubscriptionView(showsToolbar: false, subscription: subscription)
                .edgesIgnoringSafeArea(.all)
                .offset(x: viewModel.currentPage == 1 ? 0 : UIScreen.main.bounds.width)
            
            VStack {
                HStack {
                    if viewModel.currentPage != 0 {
                        Button(action: viewModel.goBack) {
                            Label("뒤로가기", systemImage: "chevron.left")
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                if viewModel.currentPage == 1 && subscription.selectedNoticeTypes.isEmpty {
                    Button("나중에 설정할게요", action: goNext)
                        .foregroundColor(
                            viewModel.currentPage == 1
                            ? .white
                            : .clear
                        )
                        .padding()
                } else {
                    Button(action: goNext) {
                        HStack {
                            Text(viewModel.currentPage == 1 ? "완료" : "계속")
                            
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(viewModel.currentPage == 1 ? ColorSet.green.color : .white)
                        .padding(.vertical)
                        .padding(.horizontal, 32)
                        .background {
                            RoundedRectangle(cornerRadius: 26)
                                .foregroundColor(viewModel.currentPage == 1 ? .white : ColorSet.green.color)
                                .frame(height: 52)
                        }
                        .padding()
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    func goNext() {
        if viewModel.currentPage == 1 {
            subscription.save()
        }
        viewModel.goNext()
    }
}
                

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: OnboardingViewModel())
    }
}
