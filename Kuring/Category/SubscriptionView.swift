//
//  SubscriptionView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/25.
//

import SwiftUI

struct SubscriptionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var subscription: NoticeTypeSubscription
    
    // TODO: StringSet
    let title: String = StringSet.Subscription.title
    let description: String = StringSet.Subscription.description
    
    let showsToolbar: Bool
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(red: 61 / 255, green: 189 / 255, blue: 128 / 255)
                    .ignoresSafeArea(.all)
                
                LazyVStack {
                    Image(systemName: "bell")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                        .clipped()
                        .padding(.bottom, 24)
                    
                    Text(description)
                        .font(.body.weight(.semibold))
                        .padding(.bottom, 20)
                    
                    SubscriptionSelection(subscription: subscription)
                }
                
            }
            .foregroundColor(.white)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.body.weight(.semibold))
                        .foregroundColor(.white)
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if showsToolbar {
                        Button(action: subscription.reset) {
                            Image(systemName: "arrow.uturn.left")
                        }
                        .foregroundColor(.white)
                        .opacity(subscription.isUpdatable ? 1 : 0.5)
                        .disabled(!subscription.isUpdatable)
                        
                        Button(action: save) {
                            Image(systemName: "checkmark")
                        }
                        .foregroundColor(.white)
                        .opacity(subscription.isUpdatable ? 1 : 0.5)
                        .disabled(!subscription.isUpdatable)
                    }
                }
            }
        }
    }
    
    init(showsToolbar: Bool = true, subscription: NoticeTypeSubscription = .init()) {
        self.showsToolbar = showsToolbar
        self.subscription = subscription
    }
    
    func save() {
        subscription.save()
        presentationMode.wrappedValue.dismiss()
    }
}




