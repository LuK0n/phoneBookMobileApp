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
            .onAppear(perform: {
                    RESTController.getContacts(token: self.userToken.value ?? "", withCompletion: {resp in
                        if case let responses as [ContactResp] = resp {
                            var contactsToRet = [Contact]()
                            for response in responses {
                                contactsToRet.append(Contact(id: response.id, name: response.name, email: response.email, phoneNumber: response.phoneNumber))
                            }
                            self.contacts = contactsToRet
                        }
                    })
                })
            .navigationBarTitle(Text("Contacts"))
            .background(
                LinearGradient(gradient: Gradient(colors:[.purple,.blue]), startPoint: .top, endPoint:.bottom).scaledToFill()
                        .edgesIgnoringSafeArea(.all))
            .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    HStack {
                                HStack {
                                    NavigationLink(destination: AddContactView()) {
                                        Image(systemName: "plus")
                                    }.foregroundColor(.white)
                                }
                    }, trailing:
                    HStack{
                        LogOutButtonView(presentationMode: presentationMode)
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
