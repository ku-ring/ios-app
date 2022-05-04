//
//  CampusStartView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons

struct CampusStartView: View {
    @ObservedObject var viewModel: CampusOnboardingViewModel
    
    var body: some View {
        VStack(spacing: 64) {
            Spacer()
  
            Image("campus.man.sitdown")
                .padding(.horizontal, 64)
                .clipped()
            
            Text("친구에게 메세지를 보내세요")
            
            Button(action: viewModel.start) {
                RoundedRectangle(cornerRadius: 26)
                    .frame(width: 232, height: 52)
                    .foregroundColor(ColorSet.green.color)
                    .overlay {
                        Text("시작하기")
                            .foregroundColor(ColorSet.Background.primary.color)
                    }
                    .padding(.bottom, 64)
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

