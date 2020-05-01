//
//  PictureModels.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/26/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import Foundation

struct CreatePictureRequest : Codable {
    var url: URL
    var contactId: UUID
}

struct PictureResponse : Codable {
    var id = UUID()
    
    var url: URL
    
    var contact: ContactId?
    
    init(id: UUID?, url: URL, contact: ContactId?) {
        self.id = id ?? UUID()
        self.url = url
        self.contact = contact
    }
}

struct DeletePictureRequest : Codable {
    var pictureId : UUID
}
