//
//  CorkageListFeature.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import ComposableArchitecture

@Reducer
public struct CorkageListFeature: Equatable {
    
    public static func == (lhs: CorkageListFeature, rhs: CorkageListFeature) -> Bool {
        return true
    }
    
    @Dependency(\.restaurantListClient) var restaurantListClient

    @ObservableState
    public struct State: Equatable {
        public var isLoading = false
        let homeCategory: HomeRestaurantCategory
        public var restaurants: [RestaurantCard] = []
        
        public init(homeCategory: HomeRestaurantCategory) {
            self.homeCategory = homeCategory
        }
    }
    
    public enum Action {
        case fetchRestaurantList
        case fetchHomeDataResponse(TaskResult<Restaurants>)
        case restaurantTapped(RestaurantCard)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchRestaurantList:
                return .run { [restaurantListClient] send in
                    await send(.fetchHomeDataResponse(
                        TaskResult {
                            try await restaurantListClient.fetch()
                        }
                    ))
                }
                
            case let .fetchHomeDataResponse(.success(fetchedData)):
                let filteredRestaurants = fetchedData.restaurants.filter { $0.category == state.homeCategory }
                    state.restaurants = filteredRestaurants
                
                return .none
                
            case let .fetchHomeDataResponse(.failure(error)):
                
                print("페치 실패: \(error)")
                return .none
                
            case .restaurantTapped(_):
                return .none
            }
        }
    }
}
