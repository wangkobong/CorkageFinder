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

        public init() {}
    }
    
    public enum Action {
        case fetchPendingRestaurants
        case fetchPendingRestaurantsResponse(TaskResult<Restaurants>)
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
            }
        }
    }
}
