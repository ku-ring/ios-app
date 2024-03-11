//
//  LaunchScreen.swift
//  KuringApp
//
//  Created by 이재성 on 3/12/24.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        Image("kuring.logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 125.34)
            .clipped()
    }
}

#Preview {
    LaunchScreen()
}
