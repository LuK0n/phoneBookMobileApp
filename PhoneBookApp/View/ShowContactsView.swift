//
//  ShowContactsView.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/21/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import SwiftUI

struct ShowContactsView: View {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userToken : UserToken
    @State var contacts = [Contact]()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    List(contacts, id: \.id) { contact in
                        NavigationLink(destination: ContactDetailView(contact: contact)) {
                                ContactRowView(contact: contact)
                        }
                    }
                Spacer()
            }
            .navigationBarTitle(Text("Contacts"))
            .background(
                LinearGradient(gradient: Gradient(colors:[.purple,.blue]), startPoint: .top, endPoint:.bottom).scaledToFill()
                        .edgesIgnoringSafeArea(.all))
            .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    HStack {
                                HStack {
                                    Button(action: {
                                        let contact = ContactResp(id: nil, name: "name", email: "mail", phoneNumber: 565789932)
                                        RESTController.addContact(token: self.userToken.value ?? "", contact: contact, withCompletion: {resp in
                                            if case let response as URLResponse = resp {
                                                if self.contacts == nil {
                                                    self.contacts = [Contact(id: contact.id, name: contact.name, email: contact.email, phoneNumber: contact.phoneNumb)]
                                                } else {
                                                self.contacts.append(Contact(id: contact.id, name: contact.name, email: contact.email, phoneNumber: contact.phoneNumb))
                                                }
                                            }
                                        })
                                    }) {
                                        Image(systemName: "plus")
                                    }.foregroundColor(.white)
                                }
                    }, trailing:
                    HStack{
                        LogOutButtonView(presentationMode: presentationMode)
                    })
            .onAppear(perform: {
                RESTController.getContacts(token: self.userToken.value ?? "", withCompletion: {resp in
                    if case let response as ContactResp = resp {
                        self.contacts = [Contact(id: response.id, name: response.name, email: response.email, phoneNumber: response.phoneNumb)]
                    }
                })
            })
        }.navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct ShowContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowContactsView()
    }
}
#endif
