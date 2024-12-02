//
//  RestaurantDetailFeature.swift
//  Feature
//
//  Created by sungyeon on 12/2/24.
//

import ComposableArchitecture

@Reducer
public struct RestaurantDetailFeature: Equatable {
    @ObservableState
    public struct State: Equatable {
        public var isLoading = false
        let restaurant: RestaurantCard

        public init(restaurant: RestaurantCard) {
            self.restaurant = restaurant
        }
    }
    
    public enum Action {
        case list
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .list:
                return .none
                
            }
        }
    }
}
