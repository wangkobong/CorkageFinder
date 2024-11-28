import SwiftUI
import Feature
import ComposableArchitecture

@main
struct CorkageFinderApp: App {
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
            ._printChanges()
    }
    var body: some Scene {
        WindowGroup {
            AppView(store: CorkageFinderApp.store)
        }
    }
}
