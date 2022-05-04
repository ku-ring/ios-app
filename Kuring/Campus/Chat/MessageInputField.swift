//
//  MessageInputField.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons

struct MessageInputField: View {
    @ObservedObject var viewModel: KuringChatViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            TextField("메세지를 입력하세요", text: $viewModel.text)
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 19)
                        .stroke(ColorSet.green.color, lineWidth: 1)
                        .frame(height: 38)
                }
                .padding(.vertical, 4)
            
            Button(action: viewModel.sendUserMessage) {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .rotationEffect(.degrees(45))
                    .foregroundColor(ColorSet.green.color)
                    .padding()
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 8)
    }
}

struct MessageInputField_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputField(viewModel: .init())
    }
}


