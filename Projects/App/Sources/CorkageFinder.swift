import SwiftUI
import Feature
import ComposableArchitecture
import KakaoMapsSDK
import FirebaseCore
import FirebaseFirestore
import FirebaseModule
import GoogleSignIn

@main
struct CorkageFinderApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
            ._printChanges()
    }
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            AppView(store: CorkageFinderApp.store)
                .onAppear {
                    if let appKey =  Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String {
                        print("앱키: \(appKey)")
                        SDKInitializer.InitSDK(appKey: appKey)
                    }
                }
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}

