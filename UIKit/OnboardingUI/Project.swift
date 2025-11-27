import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .ui,
    name: "OnboardingUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "Lottie"),
        .external(name: "ComposableArchitecture"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "Models", path: "../../Shared/Models"),
        .project(target: "Caches", path: "../../Shared/Caches"),
        .project(target: "DepartmentUI", path: "../DepartmentUI"),
        .project(target: "Networks", path: "../../Shared/Networks")
    ]
)
