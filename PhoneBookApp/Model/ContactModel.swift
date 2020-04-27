//
//  ContactModel.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/23/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import Foundation

struct Contact : Identifiable, Codable {
    
    var id = UUID()
        
    /// Contact's full name.
    var name: String
    
    /// Contact's email address.
    var email: String
    
    /// Contact's phone number.
    var phoneNumb: Int
    
    /// Relation to user
    
    init(id: UUID?, name: String, email: String, phoneNumber: Int) {
        self.id = id ?? UUID()
        self.name = name
        self.email = email
        self.phoneNumb = phoneNumber
    }
}

class ContactResp : Identifiable, Codable {

    /// Contact's unique identifier.
    var id = UUID()
    
    /// Contact's full name.
     var name: String
    
    /// Contact's email address.
     var email: String
    
    /// Contact's phone number.
     var phoneNumber: Int
    
    /// Relation to user
    var userId : UserId?
    
    init(id: UUID?, name: String, email: String, phoneNumber: Int, user: UserId?) {
        self.id = id ?? UUID()
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.userId = user
    }
}

class ContactId: Codable {
    var id: UUID
    
}
