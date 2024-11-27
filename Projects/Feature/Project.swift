import ProjectDescription

let project = Project(
    name: "Feature",
    targets: [
        .target(
            name: "Feature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.Feature",
            sources: ["Sources/**"],
            dependencies: []
        )
    ]
)
