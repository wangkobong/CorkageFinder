//
//  FirebaseClient.swift
//  FirebaseModule
//
//  Created by sungyeon on 12/9/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import Models

public struct FirebaseClient {
    public var configure: () -> Void
    public var addRestaurants: (RestaurantCard) async throws -> String
    public var getDocument: () async throws -> Void
    public var getApprovedRestaurants: () async throws -> Restaurants
    
    // 초기화 상태 체크 함수 추가
    private static func ensureFirebaseInitialized() throws {
        guard FirebaseApp.app() != nil else {
            do {
                FirebaseApp.configure()
                // 초기화 후 다시 한번 체크
                guard FirebaseApp.app() != nil else {
                    throw NSError(
                        domain: "FirebaseError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Firebase initialization failed"]
                    )
                }
            } catch {
                throw NSError(
                    domain: "FirebaseError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to configure Firebase: \(error.localizedDescription)"]
                )
            }
            return
        }
    }
    
    public static let live = Self(
        configure: {
            if FirebaseApp.app() == nil {
                FirebaseApp.configure()
            }
        },
        addRestaurants: { data in
            
            try Self.ensureFirebaseInitialized()  // 초기화 상태 체크
            let db = Firestore.firestore()

            do {
                let ref = try await db.collection("approved").addDocument(data: [
                    "imageURL": data.imageURL,
                    "name": data.name,
                    "category": data.category.rawValue,  // enum은 rawValue로 저장
                    "isCorkageFree": data.isCorkageFree,
                    "corkageFee": data.corkageFee,
                    "sido": data.sido,
                    "sigungu": data.sigungu,
                    "phoneNumber": data.phoneNumber,
                    "address": data.address,
                    "businessHours": data.businessHours,
                    "closedDays": data.closedDays,
                    "corkageNote": data.corkageNote,
                    "latitude": data.latitude ?? 0.0,
                    "longitude": data.longitude ?? 0.0,
                    "isBreaktime": data.isBreaktime,
                    "breaktime": data.breaktime
                ])
                print("Restaurant added with ID: \(ref.documentID)")
            } catch {
                print("Error adding restaurant: \(error)")
            }            
            return ""
        },
        getDocument: {
            try Self.ensureFirebaseInitialized()  // 초기화 상태 체크
            let db = Firestore.firestore()
            do {
                let querySnapshot = try await db.collection("test").getDocuments()
                for document in querySnapshot.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            } catch {
                print("Error getting documents: \(error)")
            }
        },
        getApprovedRestaurants: {
            try await Self.ensureFirebaseInitialized()
            let db = Firestore.firestore()
            
            let snapshot = try await db.collection("approved").getDocuments()
            
            let restaurantCards = try snapshot.documents.map { document in
                let data = document.data()
                
                return RestaurantCard(
                    imageURL: data["imageURL"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    category: HomeRestaurantCategory(rawValue: data["category"] as? String ?? "") ?? .korean,
                    isCorkageFree: data["isCorkageFree"] as? Bool ?? false,
                    corkageFee: data["corkageFee"] as? String ?? "",
                    sido: data["sido"] as? String ?? "",
                    sigungu: data["sigungu"] as? String ?? "",
                    phoneNumber: data["phoneNumber"] as? String ?? "",
                    address: data["address"] as? String ?? "",
                    businessHours: data["businessHours"] as? String ?? "",
                    closedDays: data["closedDays"] as? String ?? "",
                    corkageNote: data["corkageNote"] as? String ?? "",
                    latitude: data["latitude"] as? Double ?? 0.0,
                    longitude: data["longitude"] as? Double ?? 0.0,
                    isBreaktime: data["isBreaktime"] as? Bool ?? false,
                    breaktime: data["breaktime"] as? String ?? ""
                )
            }
            
            return Restaurants(restaurants: restaurantCards)
        }
    )
    
    public static let mock = Self(
        configure: { },
        addRestaurants: { _ in return "mock-document-id" },
        getDocument: { },
        getApprovedRestaurants: {
            return Restaurants(restaurants: [
                RestaurantCard(
                    imageURL: "mock-image-url",
                    name: "모크 레스토랑",
                    category: .korean,
                    isCorkageFree: true,
                    corkageFee: "30,000원",
                    sido: "서울",
                    sigungu: "강남구",
                    phoneNumber: "02-1234-5678",
                    address: "서울시 강남구 테헤란로",
                    businessHours: "11:00 - 22:00",
                    closedDays: "월요일",
                    corkageNote: "와인만 가능",
                    latitude: 37.12345,
                    longitude: 127.12345,
                    isBreaktime: true,
                    breaktime: "15:00 ~ 17:00"
                )
            ])
        }
    )
}
