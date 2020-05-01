//
//  ContactModel.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/23/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import Foundation

class Contact : Identifiable, Codable {
    
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

struct ContactModifyRequest : Codable {
    var contactId: UUID
}
