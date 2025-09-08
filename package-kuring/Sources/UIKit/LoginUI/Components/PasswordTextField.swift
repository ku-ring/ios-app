//
//  PasswordTextField.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/8/25.
//

import SwiftUI
import ColorSet

struct PasswordTextField: View {
    @Binding var showInput: Bool
    @Binding var input: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Group {
                if showInput {
                    TextField(
                        "",
                        text: $input,
                        prompt: Text("\(placeholder)").foregroundStyle(Color.Kuring.caption1)
                    )
                } else {
                    SecureField(
                        "",
                        text: $input,
                        prompt: Text("\(placeholder)").foregroundStyle(Color.Kuring.caption1)
                    )
                }
            }
            .textContentType(.password)
            .autocorrectionDisabled()
            .textCase(.lowercase)
            .font(.system(size: 16, weight: .medium))
            
            Button(action: {
                showInput.toggle()
            }, label: {
                Image(
                    showInput ? "preview_open" : "preview_close",
                    bundle: .module
                )
                .foregroundColor(.secondary)
            })
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
}
