//
//  Restaurants.swift
//  Feature
//
//  Created by sungyeon on 12/3/24.
//

import Foundation

import Foundation

public struct Restaurants: Codable, Equatable {
    public let restaurants: [RestaurantCard]
    
    public init(restaurants: [RestaurantCard]) {
        self.restaurants = restaurants
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.restaurants = try container.decode([RestaurantCard].self, forKey: .restaurants)
    }

}
