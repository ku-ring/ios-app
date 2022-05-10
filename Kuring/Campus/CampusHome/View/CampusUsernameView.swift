//
//  CampusUsernameView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons

struct CampusUsernameView: View {
    @ObservedObject var viewModel: CampusViewModel
    
    var body: some View {
        VStack(spacing: 64) {
            Spacer()
  
            Text("상대방에게 보여지는 이름을 설정해주세요.")
                .lineLimit(2)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("@")
                        .foregroundColor(ColorSet.green.color)
                    
                    TextField("이름을 입력해주세요", text: $viewModel.pendingUsername)
                        .foregroundColor(
                            viewModel.pendingUsername.conformsToUsernameProtocol
                            ? ColorSet.Label.primary.color
                            : ColorSet.pink.color
                        )
                }
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(ColorSet.green.color, lineWidth: 1)
                        .frame(height: 52)
                }
                .padding(.vertical, 4)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .font(.caption)
                        .foregroundColor(ColorSet.pink.color)
                        .padding(.horizontal)
                }
                
                Text("이름에는 \"한글, 알파벳 대소문자, 숫자, ., _\"가 가능합니다.")
                    .font(.caption)
                    .foregroundColor(ColorSet.pink.color)
                    .opacity(
                        viewModel.pendingUsername.conformsToUsernameProtocol
                        || viewModel.pendingUsername.count < 5
                        ? 0 : 1
                    )
                    .padding(.horizontal)
            }
            .padding(.horizontal, 16)
            
            
            Spacer()
            
            Button(action: viewModel.setupUsername) {
                RoundedRectangle(cornerRadius: 26)
                    .frame(width: 232, height: 52)
                    .foregroundColor(ColorSet.green.color)
                    .overlay {
                        Text("시작하기")
                            .foregroundColor(ColorSet.Background.primary.color)
                    }
                    .padding(.bottom, 64)
            }
            .opacity(viewModel.pendingUsername.isEmpty ? 0 : 1)
        }
    }
}

struct CampusUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        CampusUsernameView(viewModel: .init())
    }
}
