//
//  Constants.swift
//  Feature
//
//  Created by sungyeon on 11/29/24.
//

import Foundation

public enum HomeRestaurantCategory: String, Codable, CaseIterable {
    case korean    // 한식
    case japanese  // 일식
    case chinese   // 중식
    case western   // 양식
    case asian     // 아시안
    case etc       // 기타
    
    public var title: String {
        switch self {
        case .korean: return "한식"
        case .japanese: return "일식"
        case .chinese: return "중식"
        case .western: return "양식"
        case .asian: return "아시안"
        case .etc: return "기타"
        }
    }
    
    public var symbol: String {
        switch self {
        // SF Symbols 사용시
        case .korean: return "bowl.fill"  // 또는 "🥘"
        case .japanese: return "fish.fill"  // 또는 "🍣"
        case .chinese: return "wok.fill"  // 또는 "🥟"
        case .western: return "fork.knife"  // 또는 "🍝"
        case .asian: return "leaf.fill"  // 또는 "🍜"
        case .etc: return "ellipsis.circle.fill"  // 또는 "🍽️"
        }
    }
    
    public var emoji: String {
        switch self {
        case .korean: return "🥘"
        case .japanese: return "🍣"
        case .chinese: return "🥟"
        case .western: return "🍝"
        case .asian: return "🍜"
        case .etc: return "🥡"
        }
    }
}

public enum HTTPError: Error {
    case missingAPIKey
    case invalidURL
    case invalidResponse
    case invalidData
    case networkError
}


public enum LoginType {
    case google
    case apple
    
    public var title: String {
        switch self {
        case .google: return "구글"
        case .apple: return "애플"
        }
    }
}

public enum RestaurantState {
    case pending
    case approved
    case requestModification
    case requestDeletion
    
    public var title: String {
        switch self {
        case .pending: return "승인대기중"
        case .approved: return "승인완료"
        case .requestModification: return "수정요청"
        case .requestDeletion: return "삭제요청"
        }
    }
    
    public var DBName: String {
        switch self {
        case .pending: return "pending"
        case .approved: return "approved"
        case .requestModification: return "requestModification"
        case .requestDeletion: return "requestDeletion"
        }
    }
}
