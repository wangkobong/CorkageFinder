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
    
    let store: StoreOf<MapFeature>
    
    @State var draw: Bool = false
    var hasAppeared = false
    
    public init(store: StoreOf<MapFeature>) {
        self.store = store
    }                                                                                   
    public var body: some View {
        NavigationStack {
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
                    }
                }
                
            }

        }
    }
        
}

//#Preview {
//    CommunityView()
//}
