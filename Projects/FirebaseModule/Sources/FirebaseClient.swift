//
//  FirebaseClient.swift
//  FirebaseModule
//
//  Created by sungyeon on 12/9/24.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Models

public struct FirebaseClient {

    public var configure: () -> Void
    public var addRestaurants: (RestaurantCard) async throws -> String
    public var getDocument: () async throws -> Void
    public var getApprovedRestaurants: () async throws -> Restaurants
    public var uploadImages: ([UIImage]) async throws -> [String]
    public var deleteImages: ([String]) async throws -> Void
    
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
//            if FirebaseApp.app() == nil {
//                FirebaseApp.configure()
//            }
            return
        },
        addRestaurants: { data in
            
            try Self.ensureFirebaseInitialized()  // 초기화 상태 체크
            let db = Firestore.firestore()

            do {
                let ref = try await db.collection("approved").addDocument(data: [
                    "imageURLs": data.imageURLs,
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
                    imageURLs: data["imageURLs"] as? [String] ?? [],
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
        },
        uploadImages: { images in
            try Self.ensureFirebaseInitialized()
            let storage = Storage.storage()
            var uploadedURLs: [String] = []
            var imageRefs: [String: StorageReference] = [:]
            
            for (index, image) in images.enumerated() {
                guard let imageData = image.jpegData(compressionQuality: 0.5) else { continue }
                
                let path = "restaurants/\(UUID().uuidString).jpg"
                let imageRef = storage.reference().child(path)
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                do {
                    _ = try await imageRef.putDataAsync(imageData, metadata: metadata)
                    let downloadURL = try await imageRef.downloadURL()
                    uploadedURLs.append(downloadURL.absoluteString)
                    imageRefs[downloadURL.absoluteString] = imageRef // 참조 저장
                } catch {
                    // 이미 업로드된 이미지들 롤백
                    for url in uploadedURLs {
                        if let ref = imageRefs[url] {
                            try? await ref.delete()
                        }
                    }
                    throw error
                }
            }
            
            return uploadedURLs

        },
        deleteImages:  { urls in
            try Self.ensureFirebaseInitialized()
            let storage = Storage.storage()
            
            for url in urls {
                if let path = URL(string: url)?.lastPathComponent {
                    let imageRef = storage.reference().child("restaurants/\(path)")
                    try await imageRef.delete()
                }
            }
        }
    )
    
    public static let mock = Self(
        configure: { },
        addRestaurants: { _ in return "mock-document-id" },
        getDocument: { },
        getApprovedRestaurants: {
            return Restaurants(restaurants: [
                RestaurantCard(
                    imageURLs: ["https://firebasestorage.googleapis.com:443/v0/b/corkagefinder-90e71.firebasestorage.app/o/restaurants%2FA48B22B2-D96C-40AC-99BE-B851F1CA26C6.jpg?alt=media&token=8480042f-1bcf-42ba-be45-b69831416e0c", "https://firebasestorage.googleapis.com:443/v0/b/corkagefinder-90e71.firebasestorage.app/o/restaurants%2F4A3A6D85-339F-4E56-92E6-34ABE579D35E.jpg?alt=media&token=2dfca8ea-9d33-45a1-ac13-b0740e01004f", "https://firebasestorage.googleapis.com:443/v0/b/corkagefinder-90e71.firebasestorage.app/o/restaurants%2F0D69E80E-1852-4093-A06A-F2260BF9CFF9.jpg?alt=media&token=b147ea65-67b3-4948-b26c-f2d0c8ff5ec5"],
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
        }, 
        uploadImages: { images in
            return images.map { _ in "https://mock-image-url.com/\(UUID().uuidString).jpg" }
        },
        deleteImages: { _ in }
    )
}
