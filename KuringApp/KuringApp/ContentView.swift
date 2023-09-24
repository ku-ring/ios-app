//
//  ContentView.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/13.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NoticeList(
                store: Store(
                    initialState: .init(),
                    reducer: { NoticeListFeature() }
                )
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("kuring.label")
                }
            }
        }
    }
}


struct NoticeRow: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
            
            Text("2023.01.01")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ContentView()
}

