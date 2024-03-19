//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        Image("kuring.logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 125.34)
            .clipped()
    }
}

#Preview {
    SplashScreen()
}
