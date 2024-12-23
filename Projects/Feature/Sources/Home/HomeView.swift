//
//  HomeView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture
import KakaoMapsSDK
import Models

public struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollView(showsIndicators: false) {
                
                title
                    .padding(.top)
                
                categoryList
                    .padding(.bottom)
                
                hottestList
                    .padding(.bottom)
                
                corkageFreeList
                    .padding(.bottom)
//                Spacer()
            }
            .task {
                await store.send(.fetchHomeData).finish()
            }
        } destination: { store in
            switch store.case {
            case let .categoryList(state):
                CorkageListView(store: state)
            case let .restaurantDetail(state):
                RestaurantDetailView(store: state)
            }
        }
    }
    
    private var title: some View {
        HStack {
            Text("CorkageFinder")
                .font(.largeTitle)
                .foregroundStyle(.black)
            
            Spacer()
        }
        .padding(.leading, 16)
    }
    
    private var categoryList: some View {
       VStack(spacing: 12) {
           // 상단 행
           HStack(spacing: 12) {
               categoryBox(
                   title: "한식",
                   systemImage: "bowl.fill",
                   emoji: HomeRestaurantCategory.korean.emoji,
                   category: .korean
               )
               
               categoryBox(
                   title: "일식",
                   systemImage: "fish.fill",
                   emoji: HomeRestaurantCategory.japanese.emoji,
                   category: .japanese
               )
               
               categoryBox(
                   title: "중식",
                   systemImage: "wok.fill",
                   emoji: HomeRestaurantCategory.chinese.emoji,
                   category: .chinese
               )
           }
           
           // 하단 행
           HStack(spacing: 12) {
               categoryBox(
                   title: "양식",
                   systemImage: "fork.knife",
                   emoji: HomeRestaurantCategory.western.emoji,
                   category: .western
               )
               
               categoryBox(
                   title: "아시안",
                   systemImage: "leaf.fill",
                   emoji: HomeRestaurantCategory.asian.emoji,
                   category: .asian
               )
               
               categoryBox(
                   title: "기타",
                   systemImage: "ellipsis.circle.fill",
                   emoji: HomeRestaurantCategory.etc.emoji,
                   category: .etc
               )
           }
       }
       .padding(.horizontal)
    }
    
    private var hottestList: some View {
        
        VStack {
            HStack {
                Text("실시간 인기 콜키지")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                Spacer()
            }
            .padding(.leading, 16)
            
            // 추천 식당 리스트
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(store.recommenderRestaurants, id: \.name) { restaurant in
                        RestaurantCardView(restaurant: restaurant)
                            .onTapGesture {
                                store.send(.restaurantDetailTap(restaurant))
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
            
            Spacer()
        }
    }
    
    private var corkageFreeList: some View {
        
        VStack {
            
            HStack {
                Text("콜키지 프리")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                Spacer()
            }
            .padding(.leading, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(store.corkageFreeRestaurants, id: \.name) { restaurant in
                        RestaurantCardView(restaurant: restaurant)
                            .onTapGesture {
                                store.send(.restaurantDetailTap(restaurant))
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
            
        }
    }
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("검색어를 입력하세요", text: $store.searchText.sending(\.searchTextChanged))
                    .foregroundColor(.primary)
                    .onTapGesture {
                        store.send(.searchingStateChanged(true))
                    }
                
                if !store.searchText.isEmpty {
                    Button(action: {
                        store.send(.search(store.searchText))
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if store.isSearching {
                Button("취소") {
                    store.send(.searchCancel)
                    
                    // 키보드 내리기
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                 to: nil, from: nil, for: nil)
                }
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal)
    }
    
    private func categoryBox(title: String, systemImage: String, emoji: String, category: HomeRestaurantCategory) -> some View {
        VStack {
            //           Image(systemName: systemImage)
            //               .font(.system(size: 24))
            //               .padding(.bottom, 5)
            Text(emoji)
                .font(.system(size: 24))
                .padding(.bottom, 5)
            Text(title)
                .font(.system(size: 14, weight: .medium))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .onTapGesture {
            store.send(.tapCategoryBox(category))
        }
    }
    
    private func restaurantBox() -> some View {
        VStack {
            
        }
        .frame(width: 130, height: 200)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    HomeView(
        store: Store(
            initialState: HomeFeature.State()
        ) {
            HomeFeature()
        }
    )
}


