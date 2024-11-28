//
//  AppView.swift
//  CorkageFinder
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture
import Feature

struct AppView: View {
    
//    let store1: StoreOf<CounterFeature>
//    let store2: StoreOf<CounterFeature>
    
    let store: StoreOf<AppFeature>

    var body: some View {
        TabView {
            HomeView(store: store.scope(state: \.tab1, action: \.tab1))
              .tabItem {
                Text("홈")
              }
            
            CategoryView(store: store.scope(state: \.tab2, action: \.tab2))
              .tabItem {
                Text("카테고리")
              }
            
            CommunityView(store: store.scope(state: \.tab3, action: \.tab3))
              .tabItem {
                Text("커뮤니티")
              }
            
            MypageView(store: store.scope(state: \.tab4, action: \.tab4))
              .tabItem {
                Text("마이페이지")
              }
        }
    }
}

//#Preview {
//    AppView()
//}
