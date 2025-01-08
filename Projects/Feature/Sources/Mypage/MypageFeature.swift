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
        public var loginedUser: UserModel?
        
        public var path = StackState<Path.State>()

        public init() {}
    }
    
    public enum Action {
        case checkAuthState
        case login(LoginType)
        case logout
        case loginResponse(TaskResult<UserModel?>)
        case logoutResponse(TaskResult<Void>)
        case checkAuthStateResponse(TaskResult<UserModel?>)
        case tapToApprovalWaitingList
        
        case path(StackActionOf<Path>)
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        case approvalWatingList(ApprovalWaitingFeature)
        case restaurantDetail(RestaurantDetailFeature)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .checkAuthState:
                state.isLoading = true
                return .run { [authClient] send in
                    await send(.checkAuthStateResponse(
                        TaskResult {
                            try await authClient.isLogin()
                        }
                    ))
                }
            case .checkAuthStateResponse(.success(let user)):
                state.isLoading = false
                state.loginedUser = user
                return .none
                
            case .checkAuthStateResponse(.failure(let error)):
                state.isLoading = false
                print("Auth state check failed: \(error)")
                return .none
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
                    await send(.logoutResponse(
                        TaskResult {
                            try await authClient.logout()
                        }
                    ))
                }
                
            case let .loginResponse(.success(loginData)):
                state.loginedUser = loginData
                return .none
                
            case let .loginResponse(.failure(error)):
                state.loginedUser = nil
                print("로그인실패: \(error)")
                return .none
                
            case let .logoutResponse(.success(logoutDate)):
                state.loginedUser = nil
                return .none
                
            case let .logoutResponse(.failure(error)):
                state.loginedUser = nil
                print("로그아웃 실패: \(error)")
                return .none
            
            case .tapToApprovalWaitingList:
                state.path.append(.approvalWatingList(ApprovalWaitingFeature.State()))
                return .none
                
            case .path(.popFrom(id: _)):
                return .none
            case .path(.push(id: _, state: _)):
                return .none
            case let .path(.element(_, action)):
                switch action {
                case let .approvalWatingList(.restaurantDetailTap(restaurant)):
                    state.path.append(.restaurantDetail(RestaurantDetailFeature.State(restaurant: restaurant)))
                    return .none
                default:
                    return .none
                }
            }
        }
        .forEach(\.path, action: \.path)
    }
}
