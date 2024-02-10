//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

@resultBuilder
public enum OnboardingBuilder {
    public static func buildBlock(_ components: [Onboarding].Element?...) -> [Onboarding] {
        components.compactMap { $0 }
    }
    
    public static func buildOptional(_ component: [Onboarding]?) -> [Onboarding] {
        component ?? .init()
    }
    
    public static func buildEither(first component: [Onboarding]) -> [Onboarding] {
        component
    }
    
    public static func buildEither(second component: [Onboarding]) -> [Onboarding] {
        component
    }
    
    public static func buildArray(_ components: [[Onboarding]]) -> [Onboarding] {
        components.flatMap { $0 }
    }
    
}

