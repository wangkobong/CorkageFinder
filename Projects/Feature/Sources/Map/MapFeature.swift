//
//  CommunityFeature.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import ComposableArchitecture
import Models

@Reducer
public struct MapFeature: Equatable {
    
    public static func == (lhs: MapFeature, rhs: MapFeature) -> Bool {
        true
    }
    
    @Dependency(\.mapClient) var mapClient

    @ObservableState
    public struct State: Equatable {
        public var isLoading = false
        public var isTimerRunning = false
        public var allRestaurants: [RestaurantCard] = []
        public var isShowCard = false
        public var clickedRestaurant: RestaurantCard?
        public init() {}
    }
    
    public enum Action {
        case map
        case fetchRestaurants
        case fetchRestaurantsResponse(TaskResult<Restaurants>)
        case addRestaurantPOIs
        case tapMarker(Bool, RestaurantCard)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .map:
                return .none
                
            case .fetchRestaurants:
                state.isLoading = true
                return .run { [mapClient] send in
                    await send(.fetchRestaurantsResponse(
                        TaskResult {
                            try await mapClient.fetchRestaurants()
                        }
                    ))
                }
                
            case let .fetchRestaurantsResponse(.success(response)):
                state.allRestaurants = response.restaurants
                return .send(.addRestaurantPOIs)
                
            case let .fetchRestaurantsResponse(.failure(error)):
                
                print("페치 실패: \(error)")
                return .none
                
            case .addRestaurantPOIs:
                
                return .none
                
            case let .tapMarker(isShowCard, restaurant):
                state.isShowCard = true
                state.clickedRestaurant = restaurant
                print("restaurant: \(restaurant)")
                return .none
            }
        }
    }
}
