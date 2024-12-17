import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "FirebaseModule",
    targets: [
        .target(
            name: "FirebaseModule",
            destinations: .iOS,
            product: Environment.forPreview.getBoolean(default: false) ? .framework : .staticFramework,
            bundleId: "io.tuist.FirebaseModule",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Models", path: "../Models"),
                .external(name: "FirebaseFirestore"),
                .external(name: "FirebaseStorage"),
            ]
        ),
        .target(
            name: "FirebaseModuleTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.FirebaseModuleTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "FirebaseModule")]
        ),
    ]
)
