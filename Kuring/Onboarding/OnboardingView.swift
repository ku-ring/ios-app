//
//  OnboardingView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/02/23.
//

import SwiftUI
import KuringSDK

class OnboardingViewDelegate: ObservableObject {
    @Published var onDismiss: Bool = false
    
}

struct OnboardingView: View {
    @ObservedObject var delegate: OnboardingViewDelegate
    @State private var currentPage = 0
    @State private var selectedCategories: [NoticeType] = []
    
    
    var body: some View {
        ZStack {
            OnboardingIntroView()
                .offset(x: currentPage == 1 ? -UIScreen.main.bounds.width : 0)
            
            CategorySelectView(selectedCategories: $selectedCategories)
                .edgesIgnoringSafeArea(.all)
                .offset(x: currentPage == 1 ? 0 : UIScreen.main.bounds.width)
            
            VStack {
                HStack {
                    if currentPage != 0 {
                        Button(action: goBack) {
                            Label("뒤로가기", systemImage: "chevron.left")
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                if currentPage == 1 && selectedCategories.isEmpty {
                    Button("나중에 설정할게요", action: goNext)
                        .foregroundColor(
                            currentPage == 1
                            ? .white
                            : .clear
                        )
                        .padding()
                } else {
                    Button(action: goNext) {
                        HStack {
                            Text(currentPage == 1 ? "완료" : "계속")
                            
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(currentPage == 1 ? ColorSet.green.color : .white)
                        .padding(.vertical)
                        .padding(.horizontal, 32)
                        .background {
                            RoundedRectangle(cornerRadius: 26)
                                .foregroundColor(currentPage == 1 ? .white : ColorSet.green.color)
                                .frame(height: 52)
                        }
                        .padding()
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    func goBack() {
        if currentPage == 1 {
            withAnimation { currentPage = currentPage - 1 }
        }
    }
    
    func goNext() {
        if currentPage >= 1 {
            withAnimation { dimiss() }
        } else {
            withAnimation { currentPage = currentPage + 1 }
        }
    }
    
    func dimiss() {
        let subscribeList: [String] = selectedCategories.compactMap { $0.stringValue }
        Kuring.updateSubscription(categories: subscribeList) { _ in }
        delegate.onDismiss = true
    }
}
                

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(delegate: OnboardingViewDelegate())
    }
}
