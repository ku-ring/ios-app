//
//  SwiftUIView.swift
//
//
//  Created by 🏝️ GeonWoo Lee on 10/2/23.
//

import SwiftUI
import Combine

@MainActor
final class SearchModel: ObservableObject {
    @Published var text: String = ""
    var searchPublisher: PassthroughSubject<String, Never> = .init()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        $text
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] debouncedText in
                self?.searchPublisher.send(debouncedText)
            }
            .store(in: &subscriptions)
    }
    
    
    deinit {
        subscriptions.forEach { $0.cancel() }
    }
}

public struct SearchField: View {
    @StateObject private var dataModel = SearchModel()
    
    let placeholder: String
    
    let onSearch: (_ text: String) -> Void
    let clear: () -> Void
    
    public init(
        placeholder: String,
        onSearch: @escaping (_ text: String) -> Void,
        clear: @escaping () -> Void
    ) {
        self.placeholder = placeholder
        self.onSearch = onSearch
        self.clear = clear
    }
    
    public var body: some View {
        HStack {
            if dataModel.text.isEmpty {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
            }
            
            
            TextField(placeholder, text: $dataModel.text)
            
            if !dataModel.text.isEmpty {
                Button {
                    dataModel.text = ""
                    self.clear()
                } label: {
                    Image(systemName: "xmark.circle")
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color(red: 0.95, green: 0.95, blue: 0.96))
        )
        .padding([.horizontal, .top], 16)
        .padding(.bottom, 10)
        .onReceive(dataModel.searchPublisher) { value in
            self.onSearch(value)
        }
    }
}


// TODO: - 테스트 가능한 Preview 고민
#Preview {
    @State var searchText: String = "empty"
    
    return VStack {
        SearchField(placeholder: "PlaceHolder") { text in
            searchText = text
        } clear: {
            searchText = "clear"
        }
        
        Text(searchText)
    }
}
