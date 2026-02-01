import SwiftUI
import ClubsUI

@main
struct ClubsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                NavigationLink {
                    ClubsOnboardingView()
                        .navigationTitle("동아리")
                } label: {
                    Text("동아리 온보딩 화면")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.Kuring.primary)
                }
            }
        }
    }
}
