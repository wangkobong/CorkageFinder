//
//  Constants.swift
//  Feature
//
//  Created by sungyeon on 11/29/24.
//

import Foundation

public enum HomeRestaurantCategory: String, Codable {
    case korean    // 한식
    case japanese  // 일식
    case chinese   // 중식
    case western   // 양식
    case asian     // 아시안
    case etc       // 기타
    
    var title: String {
        switch self {
        case .korean: return "한식"
        case .japanese: return "일식"
        case .chinese: return "중식"
        case .western: return "양식"
        case .asian: return "아시안"
        case .etc: return "기타"
        }
    }
    
    var symbol: String {
        switch self {
        // SF Symbols 사용시
        case .korean: return "bowl.fill"  // 또는 "🍚"
        case .japanese: return "fish.fill"  // 또는 "🍱"
        case .chinese: return "wok.fill"  // 또는 "🥢"
        case .western: return "fork.knife"  // 또는 "🍝"
        case .asian: return "leaf.fill"  // 또는 "🍜"
        case .etc: return "ellipsis.circle.fill"  // 또는 "🍽️"
        }
    }
    
    var emoji: String {
        switch self {
        case .korean: return "🍚"
        case .japanese: return "🍱"
        case .chinese: return "🥢"
        case .western: return "🍝"
        case .asian: return "🍜"
        case .etc: return "🍽️"
        }
    }
}

public enum HTTPError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case networkError
}
