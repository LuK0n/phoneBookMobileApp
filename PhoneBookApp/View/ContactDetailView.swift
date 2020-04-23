//
//  ContactDetail.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/23/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import SwiftUI

struct ContactDetailView: View {
    
    let contact : Contact
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ContactDetail_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailView(contact: Contact(id: nil, name: "Mark Markov", email: "mail@server.com", phoneNumber: 0945648533))
    }
}
