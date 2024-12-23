//
//  RestaurantCard.swift
//  Feature
//
//  Created by sungyeon on 11/29/24.
//

import Foundation

public struct RestaurantCard: Codable, Equatable {
    public let imageURLs: [String]
    public let name: String
    public let category: HomeRestaurantCategory
    public let isCorkageFree: Bool
    public let corkageFee: String
    public let sido: String
    public let sigungu: String
    public let phoneNumber: String
    public let address: String
    public let addressDetail: String
    public let businessHours: String
    public let closedDays: String
    public let corkageNote: String
    public var latitude: Double?
    public var longitude: Double?
    public var isBreaktime: Bool
    public var breaktime: String
    
    public init(
        imageURLs: [String],
        name: String,
        category: HomeRestaurantCategory,
        isCorkageFree: Bool,
        corkageFee: String,
        sido: String,
        sigungu: String,
        phoneNumber: String,
        address: String,
        addressDetail: String,
        businessHours: String,
        closedDays: String,
        corkageNote: String,
        latitude: Double,
        longitude: Double,
        isBreaktime: Bool,
        breaktime: String
    ) {
        self.imageURLs = imageURLs
        self.name = name
        self.category = category
        self.isCorkageFree = isCorkageFree
        self.corkageFee = corkageFee
        self.sido = sido
        self.sigungu = sigungu
        self.phoneNumber = phoneNumber
        self.address = address
        self.addressDetail = addressDetail
        self.businessHours = businessHours
        self.closedDays = closedDays
        self.corkageNote = corkageNote
        self.latitude = latitude
        self.longitude = longitude
        self.isBreaktime = isBreaktime
        self.breaktime = breaktime
    }
}

extension RestaurantCard {
    public static let preview = RestaurantCard(
        imageURLs: ["https://firebasestorage.googleapis.com:443/v0/b/corkagefinder-90e71.firebasestorage.app/o/restaurants%2FA48B22B2-D96C-40AC-99BE-B851F1CA26C6.jpg?alt=media&token=8480042f-1bcf-42ba-be45-b69831416e0c", "https://firebasestorage.googleapis.com:443/v0/b/corkagefinder-90e71.firebasestorage.app/o/restaurants%2F4A3A6D85-339F-4E56-92E6-34ABE579D35E.jpg?alt=media&token=2dfca8ea-9d33-45a1-ac13-b0740e01004f", "https://firebasestorage.googleapis.com:443/v0/b/corkagefinder-90e71.firebasestorage.app/o/restaurants%2F0D69E80E-1852-4093-A06A-F2260BF9CFF9.jpg?alt=media&token=b147ea65-67b3-4948-b26c-f2d0c8ff5ec5"],
        name: "와인과 식사",
        category: .korean,
        isCorkageFree: false,
        corkageFee: "30,000원",
        sido: "서울특별시",
        sigungu: "강남구",
        phoneNumber: "02-1234-5678",
        address: "서울특별시 강남구 테헤란로 123",
        addressDetail: "송파빌딩 3층",
        businessHours: "11:30 - 22:00",
        closedDays: "매주 월요일",
        corkageNote: "와인 한 병당 콜키지 30,000원",
        latitude: 37.4979,      // 추가 (예시 좌표)
        longitude: 127.0276,     // 추가 (예시 좌표)
        isBreaktime: true,
        breaktime: "15:00 ~ 17:00"
    )
}
