//
//  RestaurantListClient.swift
//  Feature
//
//  Created by sungyeon on 12/3/24.
//

import Foundation
import ComposableArchitecture
import Models
import FirebaseModule

public struct RestaurantListClient {
    var fetch: () async throws -> Restaurants
    
    static let live = Self {
        let data = try await FirebaseClient.live.getApprovedRestaurants(.approved)
        return data
    }
}

// DependencyKey 준수
extension RestaurantListClient: DependencyKey {
    public static let liveValue = Self.live
}

// DependencyValues extension
public extension DependencyValues {
    var restaurantListClient: RestaurantListClient {
        get { self[RestaurantListClient.self] }
        set { self[RestaurantListClient.self] = newValue }
    }
}
