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
    public let displayName: String
    public let phoneNumber: String
    public let uid: String
    public let providerID: String
    public let isAdmin: Bool
    
    public init(
        name: String,
        userEmail: String,
        displayName: String,
        phoneNumber: String,
        uid: String,
        providerID: String,
        isAdmin: Bool
        
    ) {
        self.name = name
        self.userEmail = userEmail
        self.displayName = displayName
        self.phoneNumber = phoneNumber
        self.uid = uid
        self.providerID = providerID
        self.isAdmin = isAdmin
    }
}

extension UserModel {
    public static let preview = UserModel(name: "",
                                          userEmail: "",
                                          displayName: "",
                                          phoneNumber: "",
                                          uid: "",
                                          providerID: "",
                                          isAdmin: true)
}
