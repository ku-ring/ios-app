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
    @FocusState private var firstResponder: Bool
    @State private var agreesTerms: Bool = false
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("상대방에게 보여지는 이름을 설정해주세요.")
                .lineLimit(2)
            
            
            VStack(alignment: .leading) {
                Text("설정된 이름은 변경이 불가능합니다.")
                    .font(.footnote.bold())
                    .foregroundColor(ColorSet.green.color)
                
                HStack {
                    Text("@")
                        .foregroundColor(ColorSet.green.color)
                    
                    TextField("이름을 입력해주세요", text: $viewModel.pendingUsername)
                        .focused($firstResponder)
                        .foregroundColor(ColorSet.Label.primary.color)
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
                
                VStack(alignment: .leading) {
                    Text("- 이름에는 \"한글, 알파벳 대소문자, 숫자, ., _\"가 가능합니다.")
                    
                    Text("- 2~15글자 사이만 가능합니다.")
                }
                .font(.caption)
                .foregroundColor(ColorSet.pink.color)
                .opacity(viewModel.isConformsToRegex ? 0 : 1)
                .padding(.horizontal)
            }
            
            VStack(spacing: 16) {
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("[🛡개인정보 처리방침](https://kuring.notion.site/65ba27f2367044e0be7061e885e7415c) | [📄서비스 이용약관](https://kuring.notion.site/e88095d4d67d4c4c92983fd85cb693b9)")
                        .font(.footnote)
                        .lineLimit(4)
                        .padding(.bottom, 8)
                    
                    Toggle("약관에 동의합니다", isOn: $agreesTerms)
                        .toggleStyle(CheckToggleStyle())
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorSet.green.color, lineWidth: 1)
                }
                
                Button(action: viewModel.setupUsername) {
                    RoundedRectangle(cornerRadius: 26)
                        .frame(width: 232, height: 52)
                        .foregroundColor(
                            agreesTerms
                            ? ColorSet.green.color
                            : ColorSet.secondaryGray.color
                        )
                        .overlay {
                            Text("시작하기")
                                .foregroundColor(ColorSet.Background.primary.color)
                        }
                        .padding(.bottom, 64)
                }
                .disabled(!agreesTerms)
            }
            .opacity(viewModel.pendingUsername.isEmpty ? 0 : 1)
        }
        .padding(.horizontal, 16)
    }
}

struct CampusUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        CampusUsernameView(viewModel: .init())
    }
}
