//
//  Address.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/29/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import Foundation

struct Address : Identifiable, Codable {
    var id = UUID()

    /// A street of the 'Address'.
    var street: String
    
    /// A city of the 'Address'.
    var city: String
    
    /// A zip code of the 'Address'.
    var zip: String
    
    /// A house number of the 'Address'.
    var houseNr: String
    
    init(id: UUID?, street: String, city: String, zip: String, houseNr: String) {
        self.id = id ?? UUID()
        self.street = street
        self.city = city
        self.zip = zip
        self.houseNr = houseNr
    }
}

struct CreateAddressRequest : Codable {
    var street: String
    var city: String
    var zip: String
    var houseNr: String
    var contactId: UUID
    
    init(street: String, city: String, zip: String, houseNr: String, contactId: UUID) {
        self.street = street
        self.city = city
        self.zip = zip
        self.houseNr = houseNr
        self.contactId = contactId
    }
}

struct DeleteAddressRequest : Codable {
    var addressId : UUID
}

