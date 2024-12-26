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
    var tryGoogleLogin: () async throws -> Void
    var tryAppleLogin: () async throws -> Void
    var logout: () async throws -> Void
    
    static let live = Self(
        tryGoogleLogin: {
            try await FirebaseClient.live.googleLogin()
            print("Google 로그인 성공")
            return
        },
        tryAppleLogin: {
            try await FirebaseClient.live.appleLogin()
            print("apple 로그인 성공")
            return
        },
        logout: {
            try await FirebaseClient.live.logout()
            print("로그아웃시도")
            return
        })
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
