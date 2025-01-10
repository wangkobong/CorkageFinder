//
//  HomeFeatureTests.swift
//  Feature
//
//  Created by sungyeon on 1/10/25.
//

import XCTest
import ComposableArchitecture
import Models
@testable import Feature

final class HomeFeatureTests: XCTestCase {
    
    @MainActor
    func test_fetchHomeData_success() async {
        let mockHomeData = HomeData(
            recommenderRestaurants: [RestaurantCard.preview],
            corkageFreerestaurants: [RestaurantCard.preview]
        )
        
        let store = TestStore(
            initialState: HomeFeature.State(),
            reducer: { HomeFeature() }  // 리듀서를 클로저로 감싸기
        ) {
            $0.homeClient.fetch = { mockHomeData }
        }
        
        await store.send(.fetchHomeData) {
            $0.isLoading = true
        }
        
        await store.receive(.fetchHomeDataResponse(.success(mockHomeData))) {
            $0.recommenderRestaurants = mockHomeData.recommenderRestaurants
            $0.corkageFreeRestaurants = mockHomeData.corkageFreerestaurants
            $0.isLoading = false
        }
    }
    
    @MainActor
    func test_restaurantDetailTap() async {
        let restaurant = RestaurantCard.preview
        let store = TestStore(
            initialState: HomeFeature.State(),
            reducer: { HomeFeature() }
        )
        
        await store.send(.restaurantDetailTap(restaurant)) {
            $0.path.append(.restaurantDetail(RestaurantDetailFeature.State(restaurant: restaurant)))
        }
    }
    
    @MainActor
    func test_tapCategoryBox() async {
        let category = HomeRestaurantCategory.asian
        let store = TestStore(
            initialState: HomeFeature.State(),
            reducer: { HomeFeature() }
        )
        
        await store.send(.tapCategoryBox(category)) {
            $0.path.append(.categoryList(CorkageListFeature.State(homeCategory: category)))
        }
    }
    
    @MainActor
    func test_fetchHomeData_failure() async {
        let store = TestStore(
            initialState: HomeFeature.State(),
            reducer: { HomeFeature() }
        ) {
            $0.homeClient.fetch = { throw NSError(domain: "", code: -1) }
        }
        
        await store.send(.fetchHomeData) {
            $0.isLoading = true
        }
        
        await store.receive(.fetchHomeDataResponse(.failure(NSError(domain: "", code: -1)))) {
            $0.isLoading = false
        }
    }
    
}
