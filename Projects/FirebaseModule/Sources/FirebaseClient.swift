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
import FirebaseAuth
import GoogleSignIn
import AppAuth
import GTMAppAuth
import Models
import AuthenticationServices

public struct FirebaseClient {

    public var configure: () -> Void
    public var addRestaurants: (RestaurantCard) async throws -> String
    public var getDocument: () async throws -> Void
    public var getApprovedRestaurants: () async throws -> Restaurants
    public var uploadImages: ([UIImage]) async throws -> [String]
    public var deleteImages: ([String]) async throws -> Void
    public var googleLogin: () async throws -> Void
    public var appleLogin: () async throws -> Void
    public var logout: () async throws -> Void
    public var checkAuthState: () async throws -> Bool
    
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
                    "addressDetail": data.addressDetail,
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
                    addressDetail: data["addressDetail"] as? String ?? "",
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
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let dateString = dateFormatter.string(from: Date())
            
            for (index, image) in images.enumerated() {
                guard let imageData = image.jpegData(compressionQuality: 0.5) else { continue }
                
                let path = "restaurants/\(dateString)/\(UUID().uuidString).jpg"
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
        },
        googleLogin: { 
            
            // 1. Google Sign In 설정
            guard let clientID = FirebaseApp.app()?.options.clientID,
                  let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = await windowScene.windows.first?.rootViewController
            else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Client ID not found"])
            }
            
            // 2. GIDSignIn 설정
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config

            print("Configuration set successfully") // 디버깅용 로그

            // 3. 로그인 시도
            return try await withCheckedThrowingContinuation { continuation in
                print("Attempting sign in") // 디버깅용 로그
                
                DispatchQueue.main.async {
                      GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                          print("Sign in callback received")
                          
                          if let error = error {
                              continuation.resume(throwing: error)
                              return
                          }
                          
                          guard let result = result,
                                let idToken = result.user.idToken?.tokenString else {
                              continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token"]))
                              return
                          }
                          
                          let credential = GoogleAuthProvider.credential(
                              withIDToken: idToken,
                              accessToken: result.user.accessToken.tokenString
                          )
                          
                          print("로그인 성공 결과: \(result.user.description)")
                          
                          Task {
                              do {
                                  try await Auth.auth().signIn(with: credential)
                                  continuation.resume(returning: ())
                              } catch {
                                  continuation.resume(throwing: error)
                              }
                          }
                      }
                  }
            }
            
            
            

        },
        appleLogin: {
            try await Self.ensureFirebaseInitialized()
            let nonce = String.randomNonceString()
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = nonce.sha256()
            
            return try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.main.async {
                    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                    let delegate = SignInWithAppleDelegate { result, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                            return
                        }
                        
                        guard let result = result,
                              let appleIDCredential = result.credential as? ASAuthorizationAppleIDCredential,
                              let appleIDToken = appleIDCredential.identityToken,
                              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                            continuation.resume(throwing: NSError(domain: "", code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Unable to fetch identity token"]))
                            return
                        }
                        
                        let credential = OAuthProvider.credential(
                            providerID: AuthProviderID.apple,
                            idToken: idTokenString,
                            rawNonce: nonce,
                            accessToken: nil // 선택적 파라미터
                        )
                        
                        Task {
                            do {
                                try await Auth.auth().signIn(with: credential)
                                continuation.resume(returning: ())
                            } catch let signInError as NSError {
                                print("Firebase sign in error: \(signInError.localizedDescription)")
                                continuation.resume(throwing: signInError)
                            } catch {
                                print("Unexpected error: \(error.localizedDescription)")
                                continuation.resume(throwing: error)
                            }
                        }
                    }
                    
                    authorizationController.delegate = delegate
                    authorizationController.presentationContextProvider = delegate
                    objc_setAssociatedObject(authorizationController, "delegate", delegate, .OBJC_ASSOCIATION_RETAIN)
                    
                    authorizationController.performRequests()
                }
            }
            
        },
        logout: {
            try Auth.auth().signOut()
            return
        },
        checkAuthState: {
            if let user = Auth.auth().currentUser {
                print("""
                유저 정보:
                - 이메일: \(user.email ?? "없음")
                - 이름: \(user.displayName ?? "없음")
                - UID: \(user.uid)
                - 전화번호: \(user.phoneNumber ?? "없음")
                - 프로필 URL: \(user.photoURL?.absoluteString ?? "없음")
                """)
                
                // 이메일 인증 여부
                if user.isEmailVerified {
                    print("이메일 인증됨")
                }
                
                // 프로바이더 정보 (Google, Apple 등)
                for profile in user.providerData {
                    print("로그인 방식: \(profile.providerID)")
                }
            }
            return Auth.auth().currentUser != nil
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
                    addressDetail: "대박빌딩 1층",
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
        deleteImages: { _ in },
        googleLogin: {  },
        appleLogin: {  },
        logout: {  },
        checkAuthState: { return true }
    )
    
    private class SignInWithAppleDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        private let completion: (ASAuthorization?, Error?) -> Void
        
        init(completion: @escaping (ASAuthorization?, Error?) -> Void) {
            self.completion = completion
        }
        
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = scene.windows.first else {
                fatalError("No window found")
            }
            return window
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            completion(authorization, nil)
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            completion(nil, error)
        }
    }
}
