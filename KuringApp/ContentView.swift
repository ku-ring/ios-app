//
//  ContentView.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/05/20.
//

import SwiftUI
import KuringLink

struct ContentView: View {
    @State private var providers: [NoticeProvider] = []
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(providers) { department in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text(department.korName)
                                .bold()
                            
                            Text("@\(department.id)")
                                .foregroundColor(.secondary)
                        }
                        .font(.subheadline)

                        Spacer()
                        
                        Button {
                            // send action
                        } label: {
                            Text("구독하기")
                                .font(.footnote)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 6)
                                .background {
                                    Color.black
                                        .clipShape(Capsule())
                                }
                        }
                    }
                    .padding(12)
                }
            }
        }
        .task {
            do {
                let departments = try await KuringLink.allDepartments
                let univNoticeTypes = try await KuringLink.allUnivNoticeTypes
                providers.append(contentsOf: univNoticeTypes)
                providers.append(contentsOf: departments)
            } catch {
                KuringLink.console(error: error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
