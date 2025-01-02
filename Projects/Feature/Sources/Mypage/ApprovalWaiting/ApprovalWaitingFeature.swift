//
//  ApprovalWaitingFeature.swift
//  Feature
//
//  Created by sungyeon on 1/2/25.
//

import ComposableArchitecture
import Models

@Reducer
public struct ApprovalWaitingFeature: Equatable {
    
    public static func == (lhs: ApprovalWaitingFeature, rhs: ApprovalWaitingFeature) -> Bool {
        return true
    }
    
    @ObservableState
    public struct State: Equatable {
        public var isLoading = false
        public var isTimerRunning = false

        public init() {}
    }
    
    public enum Action {
        case test
    }
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .test:
                state.isLoading = true
                return .none
//                return .run { [authClient] send in
//                    await send(.checkAuthStateResponse(
//                        TaskResult {
//                            try await authClient.isLogin()
//                        }
//                    ))
//                }
            }
        }
    }
}
