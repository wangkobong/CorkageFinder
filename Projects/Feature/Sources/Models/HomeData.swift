//
//  HomeData.swift
//  Feature
//
//  Created by sungyeon on 11/29/24.
//

import Foundation

public struct HomeData: Codable, Equatable {
    let recommenderRestaurants: [RestaurantCard]
    let corkageFreerestaurants: [RestaurantCard]
}
