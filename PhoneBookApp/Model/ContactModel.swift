//
//  ContactModel.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/23/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import Foundation

class Contact : Codable, Identifiable {
    
    /// Contact's unique identifier.
    var id: UUID?
    
    /// Contact's full name.
    var name: String
    
    /// Contact's email address.
    var email: String
    
    /// Contact's phone number.
    var phoneNumber: Int
    
    /// Relation to user
    
    init(id: UUID?, name: String, email: String, phoneNumber: Int) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
    }
}
