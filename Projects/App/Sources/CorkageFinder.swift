import SwiftUI
import Feature
import ComposableArchitecture
import KakaoMapsSDK
import FirebaseCore
import FirebaseFirestore
import FirebaseModule

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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        if let app = FirebaseApp.app() {
                            do {
                                print("Firestore 초기화 직전")
                                print("Firebase 상태 확인:")
                                print("- app:", app)
                                print("- options:", app.options)
                                print("- name:", app.name)
                                print("- isDataCollectionDefaultEnabled:", app.isDataCollectionDefaultEnabled)
                                
                                let db = Firestore.firestore()
                                print("Firestore 초기화 성공:", db)
                            } catch {
                                print("Firestore 초기화 실패:", error)
                            }
                        } else {
                            print("Firebase가 사라졌습니다")
                        }
                    }
                
                }
        }
    }
}

