import ProjectDescription
import ProjectDescriptionHelpers

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
                    "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)"
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Feature", path: "../Feature"),
                .project(target: "FirebaseModule", path: "../FirebaseModule"),
                .project(target: "Models", path: "../Models"),
                .external(name: "ComposableArchitecture"),
                .external(name: "KakaoMapsSDK-SPM"),
                .external(name: "FirebaseAnalytics"),
                .external(name: "FirebaseAuth"),
                .external(name: "FirebaseFirestore"),
                .external(name: "FirebaseCore")
            ],
            settings: .settings(
                base: [
                    "KAKAO_APP_KEY": .string(SecretConfig.Keys.kakaoAppKey),
                    "OTHER_LDFLAGS": ["-ObjC"]
                ]
            )
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
