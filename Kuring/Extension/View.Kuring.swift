//
//  View.Kuring.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/03/22.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
