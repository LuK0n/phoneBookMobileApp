//
//  HTTPMethods.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 5/1/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import Foundation

enum HTTPMethod : String {
    case POST
    case GET
    case DELETE
}

enum Endpoint: String {
    case users
    case contacts
    case pictures
    case userToken
    case login
    case contactsUpdate
    case picturesGet
    case addressesGet
    case addresses
    
}
