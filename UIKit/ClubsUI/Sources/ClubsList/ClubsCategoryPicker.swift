//
//  ClubsCategoryPicker.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/8/26.
//

import SwiftUI

public struct ClubsCategoryPicker: View {
    @Binding var selection: String
    
    public var body: some View {
        HStack {
            ForEach(
                ["전체", "학술활동", "문화예술", "사회가치", "야외활동"],
                id: \.self
            ) { key in
                Button {
                    selection = key
                } label: {
                    ClubsTypeColumn(
                        key: key,
                        selection: selection
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: 48)
    }
}
