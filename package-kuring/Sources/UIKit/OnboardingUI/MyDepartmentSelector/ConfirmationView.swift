//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ColorSet

struct ConfirmationView: View {
    let department: NoticeProvider
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text(department.korName)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.accentColor)
                
                Text(
                    department.korName.last == "공"
                    ? "을"
                    : "를"
                )
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.primary)
            }
            
            Text(StringSet.title_confirm.rawValue)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.primary)
            
            Text(StringSet.description_confirm.rawValue)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.caption1.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.top, 12)
            
            Spacer()
        }
        .padding(.top, 124)
    }
}

#Preview {
    ConfirmationView(department: NoticeProvider(
        name: "영상영화학과",
        hostPrefix: "영상영화학과",
        korName: "영상영화학과",
        category: .학과)
    )
}
