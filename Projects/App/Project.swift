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
            deploymentTargets: .iOS("17.5"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)",
                    "KAKAO_API_KEY": "$(KAKAO_API_KEY)",
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
                .external(name: "GoogleSignIn")
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",  
                    "KAKAO_APP_KEY": .string(SecretConfig.Keys.kakaoAppKey),
                    "KAKAO_API_KEY": .string(SecretConfig.Keys.kakaoAPIKey),
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
