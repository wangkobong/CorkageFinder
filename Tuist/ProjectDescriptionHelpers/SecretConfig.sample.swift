import ProjectDescription
import Foundation

public struct SampleSecretConfig {
    public struct Keys {
        public static let kakaoAppKey: String = "KAKAO_APP_KEY"
        public static let kakaoAPIpKey: String = "KAKAO_API_KEY"
    }
}

public extension ProjectDescription.SettingsDictionary {
    static let sampleApiSettings: Self = [
        "KAKAO_APP_KEY": .string(SampleSecretConfig.Keys.kakaoAppKey),
        "KAKAO_API_KEY": .string(SampleSecretConfig.Keys.kakaoAPIpKey)
    ]
}
