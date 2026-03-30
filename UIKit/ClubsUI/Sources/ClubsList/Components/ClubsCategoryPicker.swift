//
//  ClubsCategoryPicker.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/8/26.
//

import Models
import SwiftUI

public struct ClubsCategoryPicker: View {
    @Binding var selection: ClubsType
    
    public var body: some View {
        HStack {
            ForEach(
                ClubsType.allCases,
                id: \.self
            ) { key in
                Button {
                    selection = key
                } label: {
                    ClubsTypeColumn(
                        original: key,
                        selection: selection
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: 48)
    }
}
