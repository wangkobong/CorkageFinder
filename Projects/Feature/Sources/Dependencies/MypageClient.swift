//
//  MypageClient.swift
//  Feature
//
//  Created by sungyeon on 1/3/25.
//

import Foundation
import ComposableArchitecture
import FirebaseModule
import Models

public struct MypageClient {
    var fetchPendingRestaurants: () async throws -> Restaurants
    var approveRestaurant: (RestaurantCard) async throws -> Bool
    var test: () async throws -> Void

    static let live = Self(
        fetchPendingRestaurants: {
            let data = try await FirebaseClient.live.getApprovedRestaurants(.pending)
            return data
        },
        approveRestaurant: { restaurant in
            let result = try await FirebaseClient.live.approveRestaurant(restaurant)
            return result
        },
        test: {
            guard let url = Bundle.main.url(forResource: "RestaurantsDummy", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                throw HTTPError.invalidURL
            }
            
            let decoder = JSONDecoder()
//            return try decoder.decode(Restaurants.self, from: data)
        }
    )
}

// DependencyKey 준수
extension MypageClient: DependencyKey {
   public static let liveValue = Self.live
}

// DependencyValues extension
public extension DependencyValues {
   var mypageClient: MypageClient {
       get { self[MypageClient.self] }
       set { self[MypageClient.self] = newValue }
   }
}
