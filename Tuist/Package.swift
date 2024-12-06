// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers


    let packageSettings = PackageSettings(
        productTypes: [
            "ComposableArchitecture": .framework,
            "KakaoMapsSDK-SPM": .staticLibrary,
            "FirebaseAnalytics": .framework,
            "FirebaseAuth": .framework,
            "FirebaseFirestore": .framework
        ]
    )

#endif

let package = Package(
    name: "CorkageFinder",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.16.1"),
        .package(url: "https://github.com/kakao-mapsSDK/KakaoMapsSDK-SPM.git", from: "2.12.2"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.6.0")
    ]
)
