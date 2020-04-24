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
     var phoneNumb: Int
    
    /// Relation to user
    
    init(id: UUID?, name: String, email: String, phoneNumber: Int) {
        self.name = name
        self.email = email
        self.phoneNumb = phoneNumber
    }
}

extension Contact: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
}


extension Contact: Equatable {

    public static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.id == rhs.id
    }
}
