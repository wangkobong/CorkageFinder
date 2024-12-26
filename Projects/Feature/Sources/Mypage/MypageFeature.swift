//
//  MypageFeature.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import ComposableArchitecture
import Models

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
        case login(LoginType)
        case logout
        case loginResponse(TaskResult<Void>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .login(loginType):
                print("인증시도")
                
                state.isLoading = true
                return .run { [authClient] send in
                    await send(.loginResponse(
                        TaskResult {
                            switch loginType {
                            case .google:
                                try await authClient.tryGoogleLogin()
                            case .apple:
                                try await authClient.tryAppleLogin()
                            }
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
