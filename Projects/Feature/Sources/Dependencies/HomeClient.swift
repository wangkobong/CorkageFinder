//
//  HomeClient.swift
//  Feature
//
//  Created by sungyeon on 11/29/24.
//

import Foundation
import ComposableArchitecture
import Models

public struct HomeClient {
    var fetch: () async throws -> HomeData
    
    static let live = Self {
        guard let url = Bundle.main.url(forResource: "RecommendRestaurantDummy", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw HTTPError.invalidURL
        }
        
//        print(Bundle.main.bundlePath)  // 번들 경로 출력
//        if let url = Bundle.main.url(forResource: "RecommendRestaurantDummy", withExtension: "json") {
//            print("Found JSON at: \(url)")
//        } else {
//            print("JSON file not found")
//        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(HomeData.self, from: data)
    }
}

// DependencyKey 준수
extension HomeClient: DependencyKey {
    public static let liveValue = Self.live
}

// DependencyValues extension
public extension DependencyValues {
    var homeClient: HomeClient {
        get { self[HomeClient.self] }
        set { self[HomeClient.self] = newValue }
    }
}
