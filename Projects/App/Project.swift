import ProjectDescription

let project = Project(
    name: "CorkageFinder",
    targets: [
        .target(
            name: "CorkageFinder",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.CorkageFinder",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Feature", path: "../Feature"),
                .external(name: "ComposableArchitecture")
            ]
        ),
        .target(
            name: "CorkageFinderTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CorkageFinderTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "CorkageFinder")]
        ),
    ]
)
