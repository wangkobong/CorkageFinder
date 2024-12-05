//
//  CategoryFeature.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import ComposableArchitecture

@Reducer
public struct RegisterRestaurantFeature: Equatable {
    @ObservableState
    public struct State: Equatable {
        public var isLoading = false
        public var isTimerRunning = false

        
        public init() {}
    }
    
    public enum Action {
        case community
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .community:
                return .none
            }
        }
    }
}
