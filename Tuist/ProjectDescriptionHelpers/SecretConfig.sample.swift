import ProjectDescription
import Foundation

public struct SampleSecretConfig {
    public struct Keys {
        public static let kakaoAppKey: String = "KAKAO_APP_KEY"
    }
}

public extension ProjectDescription.SettingsDictionary {
    static let sampleApiSettings: Self = [
        "KAKAO_APP_KEY": .string(SampleSecretConfig.Keys.kakaoAppKey)
    ]
}
