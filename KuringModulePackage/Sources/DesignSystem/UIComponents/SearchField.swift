//
//  SwiftUIView.swift
//
//
//  Created by 🏝️ GeonWoo Lee on 10/2/23.
//

import SwiftUI
import ColorSet

public struct SearchFiled: View {
    let placeHolder: String
    @Binding var searchText: String
    @Binding var clearButtonTapped: ()
    
    init(
        placeHolder: String,
        searchText: Binding<String>,
        clearButtonTapped: Binding<()>
    ) {
        self.placeHolder = placeHolder
        self._searchText = searchText
        self._clearButtonTapped = clearButtonTapped
    }
    
    public var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 12) {
                if searchText.isEmpty {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                }
                
                Section {
                    TextField(placeHolder, text: $searchText)
                    
                    if searchText.isEmpty {
                        Button {
                            clearButtonTapped = ()
                        } label: {
                            Image(systemName: "xmark")
                                .frame(width: 16, height: 16)
                                .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 7)
        .background(Color(red: 0.95, green: 0.95, blue: 0.96))
        .cornerRadius(20)
        .padding(.bottom, 16)
        
    }
}

// TODO: - 테스트 가능한 Preview 고민
#Preview {
    @State var searchText: String = ""
    @State var clearButtonTapped: () = ()
    
    return VStack {
        Text("쿠링 SearchField")
        SearchFiled(placeHolder: "", searchText: $searchText, clearButtonTapped: $clearButtonTapped)
        
        Spacer()
    }
}
