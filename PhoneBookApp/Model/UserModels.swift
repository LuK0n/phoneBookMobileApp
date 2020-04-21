//
//  UserResponse.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/18/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import Foundation

/// Data required to create a user.
struct CreateUserRequest: Codable {
    /// User's full name.
    var name: String
    
    /// User's email address.
    var email: String
    
    /// User's desired password.
    var password: String
    
    /// User's password repeated to ensure they typed it correctly.
    var verifyPassword: String
}

struct UserResponse: Codable {
    /// User's unique identifier.
    /// Not optional since we only return users that exist in the DB.
    var id: UUID
    
    /// User's full name.
    var name: String
    
    /// User's email address.
    var email: String
}

struct User: Codable {
    var id: UUID
    
    /// User's full name.
    var value: String
    
}

struct UserTokenResponse : Codable {
    var value: String

}

class UserToken : ObservableObject {
    @Published var value: String? = nil
    
}
