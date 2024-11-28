//
//  CorkageListFeature.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import ComposableArchitecture

@Reducer
public struct CorkageListFeature: Equatable {
    @ObservableState
    public struct State: Equatable {
        public var isLoading = false
        let homeCategory: HomeFeature.HomeCategory

        public init(homeCategory: HomeFeature.HomeCategory) {
            self.homeCategory = homeCategory

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
