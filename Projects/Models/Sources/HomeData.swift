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
}
