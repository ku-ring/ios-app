//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

public protocol OnboardingProvider {
    @OnboardingBuilder
    var onboardings: [Onboarding] { get }
}
