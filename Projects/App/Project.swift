import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "CorkageFinder",
    targets: [
        .target(
            name: "CorkageFinder",
            destinations: .iOS,
            product: .app,
//            bundleId: "net.daum.maps.d3ftest.KakaoMapsSDKSample", // io.tuist.CorkageFinder
            bundleId: "io.tuist.CorkageFinder", // io.tuist.CorkageFinder

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
                .external(name: "ComposableArchitecture"),
                .external(name: "KakaoMapsSDK-SPM")
            ],
            settings: .settings(
                base: [
                    "KAKAO_APP_KEY": .string(SecretConfig.Keys.kakaoAppKey)
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
