//
//  AddContactButtonView.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/23/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import SwiftUI

struct AddContactButtonView: View {
    
    @EnvironmentObject var userToken : UserToken
    @State var contact: Binding<[Contact]?>
    
    var body: some View {
        HStack {
            Button(action: {
//                RESTController.createContact(token: self.userToken.value ?? "", withCompletion: { resp in
//                    if let response = resp {
//                        if let httpResponse = response as? HTTPURLResponse {
//                            if httpResponse.statusCode == 200 {
//                                self.userToken.value = nil
                                if(self.contact.wrappedValue != nil && self.contact.wrappedValue!.count > 0) {
                                    self.contact.wrappedValue?.append(Contact(id: nil, name: "name", email: "email", phoneNumber: 444525625))
                                } else {
                                    self.contact.wrappedValue = [Contact(id: nil, name: "name", email: "email", phoneNumber: 444525625)]
                                }
//                            }
//                        }
//                    }
//                })
            }) {
                Image(systemName: "plus")
            }.foregroundColor(.white)
        }
    }
}
