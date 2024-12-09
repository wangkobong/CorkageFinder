//
//  FirebaseClient.swift
//  FirebaseModule
//
//  Created by sungyeon on 12/9/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

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

//            do {
//                let db = Firestore.firestore()
//                let ref = try await db.collection("users").addDocument(data: data)
//                print("Document added with ID: \(ref.documentID)")
//                return ref.documentID
//            } catch {
//                throw error
//            }
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
