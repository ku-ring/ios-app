//
//  ContentView.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/13.
//

import SwiftUI
import NoticeListFeature
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
struct NoticeList: View {
    let store: StoreOf<NoticeListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List {
                ForEach(viewStore.notices) {
                    NoticeRow(title: $0.subject)
                }
            }
            .listStyle(.plain)
            .onAppear {
                viewStore.send(.onAppear)
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


#Preview {
    NoticeList(
        store: Store(
            initialState: NoticeListFeature.State(),
            reducer: { NoticeListFeature() }
        )
    )
}

