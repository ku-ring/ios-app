//
//  EmailTextField.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/8/25.
//

import SwiftUI
import ColorSet

struct EmailTextField: View {
    @Binding var email: String
    let placeholder: String
    
    var body: some View {
        TextField(
            "",
            text: $email,
            prompt: Text(placeholder).foregroundStyle(Color.Kuring.caption1)
        )
        .keyboardType(.emailAddress)
        .textContentType(.emailAddress)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .frame(height: 50)
        .padding(.horizontal)
    }
}
