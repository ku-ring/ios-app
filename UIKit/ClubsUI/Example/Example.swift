import SwiftUI
import ClubsUI

@main
struct ClubsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack(spacing: 24) {
                    NavigationLink {
                        ClubsOnboardingView()
                            .navigationTitle("동아리")
                    } label: {
                        Text("동아리 온보딩 화면")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.Kuring.primary)
                    }
                    
                    NavigationLink {
                        ClubsContentView()
                            .navigationTitle("동아리")
                    } label: {
                        Text("동아리")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.Kuring.primary)
                    }
                    
                    NavigationLink {
                        ClubInfoDetailView()
                            .navigationTitle("동아리")
                    } label: {
                        Text("동아리 상세")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.Kuring.primary)
                    }
                    
                    NavigationLink {
                        ClubsSubscriptionView()
                            .navigationTitle("구독")
                    } label: {
                        Text("구독")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.Kuring.primary)
                    }
                }
            }
        }
    }
}
