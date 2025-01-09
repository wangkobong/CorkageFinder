//
//  CommunityView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture
import KakaoMapsSDK

public struct MapView: View {
    
    @Bindable var store: StoreOf<MapFeature>
    
    @State var draw: Bool = false
    var hasAppeared = false
    
    public init(store: StoreOf<MapFeature>) {
        self.store = store
    }                                                                                   
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ZStack {
                KakaoMapView(draw: $draw, store: store).onAppear(perform: {
                    self.draw = true
                    if !hasAppeared {
                        store.send(.fetchRestaurants)
                    }
                }).onDisappear(perform: {
                    self.draw = false
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
                if store.state.clickedRestaurant != nil {
                    VStack {
                        Spacer()
                        MapRestaurantCardView(restaurant: store.state.clickedRestaurant!)
                            .padding(.bottom)
                            .onTapGesture {
                                store.send(.tapCard(store.state.clickedRestaurant!))
                            }
                    }
                }
                
            }

        } destination: { store in
            switch store.case {
            case let .restaurantDetail(state):
                RestaurantDetailView(store: state)
            }
        }
        .loadingOverlay(isLoading: store.isLoading)
    }
        
}

//#Preview {
//    CommunityView()
//}
