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
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .external(name: "KakaoMapsSDK-SPM"),
                .external(name: "FirebaseAnalytics"),
                .external(name: "FirebaseAuth"),
                .external(name: "FirebaseFirestore")
            ],
            settings: .settings(
                base: [
                    "ENABLE_PREVIEWS": "YES",
                    "KAKAO_APP_KEY": .string(SecretConfig.Keys.kakaoAppKey)
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
