//
//  LoginErrorMessage.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/8/25.
//

import SwiftUI
import ColorSet

struct LoginErrorMessage: View {
    let message: String
    
    var body: some View {
        Text("\(message)")
            .font(.caption2.weight(.medium))
            .foregroundStyle(Color.Kuring.warning)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
    }
}
