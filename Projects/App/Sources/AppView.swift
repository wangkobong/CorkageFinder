//
//  AppView.swift
//  CorkageFinder
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture
import Feature
import FirebaseFirestore

struct AppView: View {
    
    let store: StoreOf<AppFeature>

    var body: some View {
        TabView {
            HomeView(store: store.scope(state: \.tab1, action: \.tab1))
              .tabItem {
                  VStack {
                      Image(systemName: "house.fill")
                      Text("홈")
                  }
              }
            
            MapView(store: store.scope(state: \.tab2, action: \.tab2))
              .tabItem {
                  VStack {
                      Image(systemName: "map.fill")
                      Text("내주변")
                  }
              }
            
            RegisterRestaurantView(store: store.scope(state: \.tab3, action: \.tab3))
              .tabItem {
                  VStack {
                      Image(systemName: "square.and.pencil")
                      Text("등록")
                  }
              }
            
            MypageView(store: store.scope(state: \.tab4, action: \.tab4))
              .tabItem {
                  VStack {
                      Image(systemName: "person.fill")
                      Text("마이페이지")
                  }
              }
        }

    }
}

#Preview {
    AppView(
        store: Store(
            initialState: AppFeature.State(
                tab1: HomeFeature.State(),
                tab2: MapFeature.State(),
                tab3: RegisterRestaurantFeature.State(),
                tab4: MypageFeature.State()
            )
        ) {
            AppFeature()
        }
    )
}
