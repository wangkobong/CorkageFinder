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

        
        public init() {}
    }
    
    public enum Action {
        case map
        case fetchRestaurants
        case fetchRestaurantsResponse(TaskResult<Restaurants>)
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
                
            case let .fetchRestaurantsResponse(.success(restaurans)):
                print("긁어온 식당들: \(restaurans)")
                return .none
                
            case let .fetchRestaurantsResponse(.failure(error)):
                
                print("페치 실패: \(error)")
                return .none
            }
        }
    }
}
