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
    public var addDocument: ([String: Any]) async throws -> String
    public var getDocument: () async throws -> Void
    
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
        addDocument: { data in
            
            try Self.ensureFirebaseInitialized()  // 초기화 상태 체크
            let db = Firestore.firestore()

            let restaurant = RestaurantCard(imageURL: "",
                                      name: "이자카야 료",
                                      category: .japanese,
                                      isCorkageFree: true,
                                      corkageFee: "무료",
                                      sido: "경기도",
                                      sigungu: "분당구",
                                      phoneNumber: "031-712-5678",
                                      address: "경기도 성남시 분당구 수내동 012-34",
                                      businessHours: "17:00 - 23:30",
                                      closedDays: "매주 월요일",
                                      corkageNote: "콜키지 무료, 일본 사케 반입 가능")

            do {
                let ref = try await db.collection("restaurants").addDocument(data: [
                    "imageURL": restaurant.imageURL,
                    "name": restaurant.name,
                    "category": restaurant.category.rawValue,  // enum은 rawValue로 저장
                    "isCorkageFree": restaurant.isCorkageFree,
                    "corkageFee": restaurant.corkageFee,
                    "sido": restaurant.sido,
                    "sigungu": restaurant.sigungu,
                    "phoneNumber": restaurant.phoneNumber,
                    "address": restaurant.address,
                    "businessHours": restaurant.businessHours,
                    "closedDays": restaurant.closedDays,
                    "corkageNote": restaurant.corkageNote
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
        }
    )
    
    public static let mock = Self(
        configure: { },
        addDocument: { _ in return "mock-document-id" },
        getDocument: { }
    )
}
