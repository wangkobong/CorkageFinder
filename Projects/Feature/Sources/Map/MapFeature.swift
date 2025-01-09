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
        public var clickedRestaurant: RestaurantCard?
        
        public var path = StackState<Path.State>()

        public init() {}
    }
    
    public enum Action {
        case fetchRestaurants
        case fetchRestaurantsResponse(TaskResult<Restaurants>)
        case addRestaurantPOIs
        case tapMarker(RestaurantCard)
        case tapCard(RestaurantCard)
        case path(StackActionOf<Path>)
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        case restaurantDetail(RestaurantDetailFeature)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

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
                state.isLoading = false
                return .send(.addRestaurantPOIs)
                
            case let .fetchRestaurantsResponse(.failure(error)):
                print("페치 실패: \(error)")
                state.isLoading = false
                return .none
                
            case .addRestaurantPOIs:
                
                return .none
                
            case let .tapMarker(restaurant):
                state.clickedRestaurant = restaurant
                print("restaurant: \(restaurant)")
                return .none
                
            case let .tapCard(restaurant):
                state.path.append(.restaurantDetail(RestaurantDetailFeature.State(restaurant: restaurant)))
                return .none
            case .path(.popFrom(id: _)):
                return .none
            case .path(.push(id: _, state: _)):
                return .none
            case .path(.element(id: _, action: let action)):
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
