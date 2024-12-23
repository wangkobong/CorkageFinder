//
//  RegisterRestaurantClient.swift
//  Feature
//
//  Created by sungyeon on 12/6/24.
//

import UIKit
import ComposableArchitecture
import FirebaseModule
import Models

public struct RegisterRestaurantClient {
    var test: () async throws -> Restaurants
    var saveRestaurant: (RestaurantCard) async throws -> Bool  // 저장 함수 추가
    var saveImages: ([UIImage]) async throws -> [String]
    
    static let live = Self(
        test: {
            guard let url = Bundle.main.url(forResource: "RestaurantsDummy", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                throw HTTPError.invalidURL
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(Restaurants.self, from: data)
        },
        saveRestaurant: { restaurant in  // 테스트용 저장 구현
            // 여기서는 테스트를 위해 항상 성공 반환
            //           try await Task.sleep(nanoseconds: 1_000_000_000)  // 1초 딜레이
            //           try await FirebaseClient.live.addDocument(["테스트":1])
            //           try await FirebaseClient.live.getDocument()
            try await FirebaseClient.live.addRestaurants(restaurant)
            return true
        },
        saveImages: { images in
            
            let imageURLs = try await FirebaseClient.live.uploadImages(images)
            return imageURLs
        }
    )
}

// DependencyKey 준수
extension RegisterRestaurantClient: DependencyKey {
   public static let liveValue = Self.live
}

// DependencyValues extension
public extension DependencyValues {
   var registerRestaurantClient: RegisterRestaurantClient {
       get { self[RegisterRestaurantClient.self] }
       set { self[RegisterRestaurantClient.self] = newValue }
   }
}
