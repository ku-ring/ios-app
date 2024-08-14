//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet
import BotFeatures
import BotUI
import ComposableArchitecture

public struct BotFloatButton: View {
    
    public var body: some View {
        NavigationLink(
            destination:
                BotView(
                    store: Store(
                        initialState: BotFeature.State(),
                        reducer: { BotFeature() })
                )
                .toolbar(.hidden, for: .tabBar)
        ) {
                    ZStack {
                        Circle()
                            .fill(Color.Kuring.primary)
                            .frame(width: 64, height: 64)
                            .shadow(radius: 5)
                        
                        VStack(alignment: .center) {
                            Image("kuring_app_white", bundle: Bundle.bots)
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            Text("쿠링봇")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 5)
                    }
                    .padding(.bottom, 20)
                    .padding(.trailing, 16)
                }

    }
}

