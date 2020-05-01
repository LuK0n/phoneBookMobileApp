//
//  GenericResponse.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 5/1/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import Foundation

class GenericResponse : Codable {
    var statusCode : Int
    
    init(code: Int) {
        self.statusCode = code
    }
}
