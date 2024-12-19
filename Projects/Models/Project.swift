import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Models",
    targets: [
        .target(
            name: "Models",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.Models",
            deploymentTargets: .iOS("17.5"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
            ]
        ),
        .target(
            name: "ModelsTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.ModelsTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "Models")]
        ),
    ]
)
