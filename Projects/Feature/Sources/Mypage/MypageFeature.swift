//
//  MypageFeature.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import ComposableArchitecture

@Reducer
public struct MypageFeature: Equatable {
    
    public static func == (lhs: MypageFeature, rhs: MypageFeature) -> Bool {
        return true
    }
    
    @Dependency(\.authClient) var authClient

    @ObservableState
    public struct State: Equatable {
        public var isLoading = false
        public var isTimerRunning = false
        public var isLogined = false
        
        public init() {}
    }
    
    public enum Action {
        case login
        case logout
        case loginResponse(TaskResult<Void>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .login:
                print("인증시도")
                
                state.isLoading = true
                return .run { [authClient] send in
                    await send(.loginResponse(
                        TaskResult {
                            try await authClient.login()
                        }
                    ))
                }
                
            case .logout:
                state.isLoading = true
                return .run { [authClient] send in
                    await send(.loginResponse(
                        TaskResult {
                            try await authClient.logout()
                        }
                    ))
                }
                
            case let .loginResponse(.success(loginData)):
                
                return .none
                
            case let .loginResponse(.failure(error)):
                
                print("로그인실패: \(error)")
                return .none
            }
        }
    }
}
