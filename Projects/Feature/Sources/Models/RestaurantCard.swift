//
//  RestaurantCard.swift
//  Feature
//
//  Created by sungyeon on 11/29/24.
//

import Foundation

public struct RestaurantCard: Codable, Equatable {
    public let imageURL: String
    public let name: String
    public let category: HomeRestaurantCategory
    public let isCorkageFree: Bool
    public let corkageFee: String
    public let sido: String
    public let sigungu: String
    
    public init(imageURL: String, name: String, category: HomeRestaurantCategory,
                isCorkageFree: Bool, corkageFee: String, sido: String, sigungu: String) {
        self.imageURL = imageURL
        self.name = name
        self.category = category
        self.isCorkageFree = isCorkageFree
        self.corkageFee = corkageFee
        self.sido = sido
        self.sigungu = sigungu
    }
}