//
//  CorkageListView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture

struct CorkageListView: View {
    
    @Bindable var store: StoreOf<CorkageListFeature>
    
    public init(store: StoreOf<CorkageListFeature>) {
        self.store = store
    }
    
    var body: some View {
        List(store.restaurants, id: \.name) { restaurant in
            RestaurantRowView(restaurant: restaurant)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .onTapGesture {
                    store.send(.restaurantTapped(restaurant))
                }
        }
        .listStyle(.plain)
        .navigationTitle(Text(store.homeCategory.title))
        .task {
            await store.send(.fetchRestaurantList).finish()
        }
    }
}

#Preview {
    CorkageListView(
        store: Store(
            initialState: CorkageListFeature.State(homeCategory: .korean)
        ) {
            CorkageListFeature()
        }
    )
}
