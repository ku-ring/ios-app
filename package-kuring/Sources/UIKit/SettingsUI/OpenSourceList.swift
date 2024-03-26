//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet
import SettingsFeatures
import ComposableArchitecture

public struct OpenSourceList: View {
    @Bindable public var store: StoreOf<OpenSourceListFeature>

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("쿠링에 사용된\n오픈소스예요")
                .foregroundStyle(Color.Kuring.title)
                .font(.system(size: 24, weight: .bold))
                .padding(.vertical, 32)
                .padding(.horizontal, 20)
            
            List {
                ForEach(store.opensources) { opensource in
                    ZStack {
                        NavigationLink {
                            OpenSourceDetailView(opensource: opensource) {
                                store.send(.linkTapped(opensource.link))
                            }
                            .navigationTitle(opensource.name)
                        } label: {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        OpenSourceRow(opensource: opensource)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(
                    .init(top: 0, leading: 0, bottom: 0, trailing: 0)
                )
            }
            .listStyle(.plain)
        }
        .background {
            Color.Kuring.bg
                .ignoresSafeArea()
        }
    }

    public init(store: StoreOf<OpenSourceListFeature>) {
        self.store = store
    }
}

public struct OpenSourceRow: View {
    let opensource: Opensource
    
    public var body: some View {
        HStack(spacing: 10) {
            Image("icon_star", bundle: .settings)
                .resizable()
                .frame(width: 24, height: 24)
                .clipped()
            
            Text(opensource.name)
                .foregroundStyle(Color.Kuring.title)
            
            Spacer()
            
            Image("chevron", bundle: .settings)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.Kuring.gray300)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background {
            Color.Kuring.bg
                .ignoresSafeArea()
        }
    }
}

public struct OpenSourceDetailView: View {
    let opensource: Opensource
    let action: () -> Void
    
    var 조사: String {
        opensource.purpose.contains("통신모듈")
        ? "은"
        : "는"
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                Text("쿠링에 사용된\n\(opensource.purpose)\(조사)요")
                    .foregroundStyle(Color.Kuring.title)
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 32)
                    .padding(.bottom, 60)
                
                VStack(alignment: .leading, spacing: 7) {
                    if let description = opensource.description {
                        Text(description)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color.Kuring.title)
                    }
                    
                    Button {
                        action()
                    } label: {
                        HStack(spacing: 2) {
                            Text(opensource.linkName)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.Kuring.caption2)
                            
                            Image("icon_external_link", bundle: .settings)
                                .resizable()
                                .frame(width: 23, height: 23)
                                .clipped()
                        }
                    }
                    .padding(.bottom, 16)
                    
                    Text(opensource.license)
                }
            }
            .padding(.horizontal, 20)
        }
        .background {
            Color.Kuring.bg
                .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationStack {
        OpenSourceList(
            store: Store(
                initialState: OpenSourceListFeature.State(),
                reducer: { OpenSourceListFeature() }
            )
        )
        .navigationTitle("사용된 오픈소스")
        .navigationBarTitleDisplayMode(.inline)
    }
}
