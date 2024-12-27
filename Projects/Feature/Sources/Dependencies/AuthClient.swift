//
//  AuthClient.swift
//  Feature
//
//  Created by sungyeon on 12/24/24.
//

import UIKit
import ComposableArchitecture
import FirebaseModule
import Models

public struct AuthClient {
    var tryGoogleLogin: () async throws -> UserModel?
    var tryAppleLogin: () async throws -> UserModel?
    var logout: () async throws -> Void
    var isLogin: () async throws -> UserModel?
    
    static let live = Self(
        tryGoogleLogin: {
            return try await FirebaseClient.live.googleLogin()
        },
        tryAppleLogin: {
            return try await FirebaseClient.live.appleLogin()
        },
        logout: {
            try await FirebaseClient.live.logout()
            print("로그아웃시도")
            return
        },
        isLogin: {
            return try await FirebaseClient.live.checkAuthState()
        }
    )
}

// DependencyKey 준수
extension AuthClient: DependencyKey {
   public static let liveValue = Self.live
}

// DependencyValues extension
public extension DependencyValues {
   var authClient: AuthClient {
       get { self[AuthClient.self] }
       set { self[AuthClient.self] = newValue }
   }
}
