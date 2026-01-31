import SwiftUI
import ClubsUI

@main
struct ClubsApp: App {
    var body: some Scene {
        WindowGroup {
            ClubsOnboardingView()
                .navigationTitle("동아리")
        }
    }
}
