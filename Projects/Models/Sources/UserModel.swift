//
//  UserModel.swift
//  Models
//
//  Created by sungyeon on 12/26/24.
//

import Foundation

public struct UserModel: Codable, Equatable {
    public let name: String
    public let userEmail: String
    public let phoneNumber: String
    public let uid: String
    public let loginType: String
    public let isAdmin: Bool
    
    public init(
        name: String,
        userEmail: String,
        phoneNumber: String,
        uid: String,
        loginType: String,
        isAdmin: Bool
        
    ) {
        self.name = name
        self.userEmail = userEmail
        self.phoneNumber = phoneNumber
        self.uid = uid
        self.loginType = loginType
        self.isAdmin = isAdmin
    }
}

extension UserModel {
    public static let preview = UserModel(name: "",
                                          userEmail: "",
                                          phoneNumber: "",
                                          uid: "",
                                          loginType: "",
                                          isAdmin: true)
}
