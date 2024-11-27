// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "ComposableArchitecture": .framework
        ]
    )

#endif

let package = Package(
    name: "CorkageFinder",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.16.1")
    ]
)
