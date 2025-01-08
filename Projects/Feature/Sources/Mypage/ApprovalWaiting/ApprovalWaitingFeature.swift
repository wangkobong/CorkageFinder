//
//  ApprovalWaitingFeature.swift
//  Feature
//
//  Created by sungyeon on 1/2/25.
//

import ComposableArchitecture
import Models
import FirebaseModule

@Reducer
public struct ApprovalWaitingFeature: Equatable {
    
    public static func == (lhs: ApprovalWaitingFeature, rhs: ApprovalWaitingFeature) -> Bool {
        return true
    }
    
    @Dependency(\.mypageClient) var mypageClient
    
    @ObservableState
    public struct State: Equatable {
        public var isLoading = false
        public var isTimerRunning = false
        public var pendingRestaurants: [RestaurantCard] = []

        public var path = StackState<Path.State>()

        public init() {}
    }
    
    public enum Action {
        case fetchPendingRestaurants
        case fetchPendingRestaurantsResponse(TaskResult<Restaurants>)
        case path(StackActionOf<Path>)
        case restaurantDetailTap(RestaurantCard)
        case approve(RestaurantCard)
        case approveRestaurantResponse(TaskResult<Bool>)
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        case restaurantDetail(RestaurantDetailFeature)
    }
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchPendingRestaurants:
                state.isLoading = true
                return .run { [mypageClient] send in
                    await send(.fetchPendingRestaurantsResponse(
                        TaskResult {
                            try await mypageClient.fetchPendingRestaurants()
                        }
                    ))
                }
            case let .fetchPendingRestaurantsResponse(.success(response)):
                state.pendingRestaurants = response.restaurants
                return .none
                
            case let .fetchPendingRestaurantsResponse(.failure(error)):
                print("페치 실패: \(error)")
                return .none
                
            case let .approve(restaurant):
                state.isLoading = true
                return .run { [mypageClient] send in
                    await send(.approveRestaurantResponse(
                        TaskResult {
                            try await mypageClient.approveRestaurant(restaurant)
                        }
                    ))
                }
                
            case let .approveRestaurantResponse(.success(response)):
                if response == true {
                    return .send(.fetchPendingRestaurants)
                }
                return .none
            case let .approveRestaurantResponse(.failure(error)):
                print("페치 실패: \(error)")
                return .none
            case let .restaurantDetailTap(restaurant):
                state.path.append(.restaurantDetail(RestaurantDetailFeature.State(restaurant: restaurant)))
                return .none
            case .path(.popFrom(id: _)):
                return .none
            case .path(.push(id: _, state: _)):
                return .none
            case .path(.element(id: let id, action: let action)):
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
