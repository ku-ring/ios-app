import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.ui(
    name: "OnboardingUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "Lottie"),
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../../Models"),
        .project(target: "Caches", path: "../../Caches"),
        .project(target: "Networks", path: "../../Networks"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "DepartmentUI", path: "../DepartmentUI"),
    ]
)
