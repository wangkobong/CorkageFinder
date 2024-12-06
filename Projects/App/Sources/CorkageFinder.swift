import SwiftUI
import Feature
import ComposableArchitecture
import KakaoMapsSDK
import FirebaseCore

@main
struct CorkageFinderApp: App {
    
    init() {

    }
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
            ._printChanges()
    }
    var body: some Scene {
        WindowGroup {
            AppView(store: CorkageFinderApp.store)
                .onAppear {
                    if let appKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String {
                        print("앱키: \(appKey)")
                        SDKInitializer.InitSDK(appKey: appKey)
                    }
                    FirebaseApp.configure()
                }
        }
    }
}
