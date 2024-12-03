//
//  RestaurantListClient.swift
//  Feature
//
//  Created by sungyeon on 12/3/24.
//

import Foundation
import ComposableArchitecture

public struct RestaurantListClient {
    var fetch: () async throws -> Restaurants
    
    static let live = Self {
        guard let url = Bundle.main.url(forResource: "RestaurantsDummy", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw HTTPError.invalidURL
        }
        
        print(Bundle.main.bundlePath)  // 번들 경로 출력
        if let url = Bundle.main.url(forResource: "RestaurantsDummy", withExtension: "json") {
            print("Found JSON at: \(url)")
        } else {
            print("JSON file not found")
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(Restaurants.self, from: data)
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
