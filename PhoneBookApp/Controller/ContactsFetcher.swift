//
//  ContactsFetcher.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/27/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import Foundation
import Combine
public class ContactsFetcher: ObservableObject {

    @Published var contacts = [Contact]()
    
    init(){
        load()
    }
    
    func load() {
        RESTController.getContacts(withCompletion: {resp in
            if case let responses as [ContactResp] = resp {
                var contactsToRet = [Contact]()
                for response in responses {
                    contactsToRet.append(Contact(id: response.id, name: response.name, email: response.email, phoneNumber: response.phoneNumber))
                }
                self.contacts = contactsToRet
            }
        })
         
    }
}
