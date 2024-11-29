import ProjectDescription

let project = Project(
    name: "Feature",
    targets: [
        .target(
            name: "Feature",
            destinations: .iOS,
            product: Environment.forPreview.getBoolean(default: false) ? .framework : .staticFramework,
            bundleId: "io.tuist.Feature",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "ComposableArchitecture")
            ],
            settings: .settings(
                base: [
                    "ENABLE_PREVIEWS": "YES"
                ]
            )
        ),
        .target(
            name: "FeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.FeatureTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "Feature")]
        ),
    ]
)
