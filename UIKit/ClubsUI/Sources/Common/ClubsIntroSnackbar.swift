//
//  ClubsIntroSnackbar.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/13/26.
//

import SwiftUI
import ColorSet

struct ClubsIntroSnackbar: View {
    var body: some View {
        VStack {
            Text("⭐️ 해당 동아리 마감 하루 전에 알려드릴게요!")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color(uiColor: .init(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)))
                .padding(.vertical, 18)
        }
        .frame(maxWidth: .infinity)
        .background(
            TransparentBlurView(
                blur: 6,
                color: Color(uiColor: .init(red: 0.20, green: 0.28, blue: 0.24, alpha: 0.5))
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    ClubsIntroSnackbar()
}
