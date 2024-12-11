//
//  MapClient.swift
//  Feature
//
//  Created by sungyeon on 12/11/24.
//

import Foundation
import ComposableArchitecture
import FirebaseModule
import Models

public struct MapClient {
    var fetchRestaurants: () async throws -> Restaurants
    var test: () async throws -> Void

    static let live = Self(
        fetchRestaurants: {
            let data = try await FirebaseClient.live.getApprovedRestaurants()
            return data
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
extension MapClient: DependencyKey {
   public static let liveValue = Self.live
}

// DependencyValues extension
public extension DependencyValues {
   var mapClient: MapClient {
       get { self[MapClient.self] }
       set { self[MapClient.self] = newValue }
   }
}
