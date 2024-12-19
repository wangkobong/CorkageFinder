import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Feature",
    targets: [
        .target(
            name: "Feature",
            destinations: .iOS,
            product: Environment.forPreview.getBoolean(default: false) ? .framework : .staticFramework,
            bundleId: "io.tuist.Feature",
            deploymentTargets: .iOS("17.5"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "FirebaseModule", path: "../FirebaseModule"),
                .project(target: "Models", path: "../Models"),
                .external(name: "ComposableArchitecture"),
                .external(name: "KakaoMapsSDK-SPM"),
                .external(name: "Kingfisher")
            ],
            settings: .settings(
                base: [
                    "ENABLE_PREVIEWS": "YES",
                    "KAKAO_APP_KEY": .string(SecretConfig.Keys.kakaoAppKey),
                    "KAKAO_API_KEY": .string(SecretConfig.Keys.kakaoAPIKey),
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
