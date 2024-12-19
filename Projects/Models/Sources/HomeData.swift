//
//  HomeData.swift
//  Feature
//
//  Created by sungyeon on 11/29/24.
//

import Foundation

public struct HomeData: Codable, Equatable {
    public let recommenderRestaurants: [RestaurantCard]
    public let corkageFreerestaurants: [RestaurantCard]
    
    public init(recommenderRestaurants: [RestaurantCard], corkageFreerestaurants: [RestaurantCard]) {
        self.recommenderRestaurants = recommenderRestaurants
        self.corkageFreerestaurants = corkageFreerestaurants
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.recommenderRestaurants = try container.decode([RestaurantCard].self, forKey: .recommenderRestaurants)
        self.corkageFreerestaurants = try container.decode([RestaurantCard].self, forKey: .corkageFreerestaurants)
    }
}
