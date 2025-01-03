//
//  HomeClient.swift
//  Feature
//
//  Created by sungyeon on 11/29/24.
//

import Foundation
import ComposableArchitecture
import Models
import FirebaseModule

public struct HomeClient {
    var fetch: () async throws -> HomeData
    
    static let live = Self {
        let data = try await FirebaseClient.live.getApprovedRestaurants(.approved)
        
        // 콜키지 무료인 식당들 필터링
        let corkageFreeRestaurants = data.restaurants.filter { $0.isCorkageFree }
        
        // 추천 식당은 전체 식당 중에서 랜덤으로 선택하거나,
        // 특정 조건으로 필터링할 수 있습니다
        let recommendedRestaurants = Array(data.restaurants.shuffled().prefix(5))  // 예시로 랜덤 5개 선택
        return HomeData(recommenderRestaurants: recommendedRestaurants,
                        corkageFreerestaurants: corkageFreeRestaurants)
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
