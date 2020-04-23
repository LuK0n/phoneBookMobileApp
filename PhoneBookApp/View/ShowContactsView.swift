//
//  ShowContactsView.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/21/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import SwiftUI

struct ShowContactsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userToken : UserToken
    @State var contacts : [Contact]?
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                if contacts != nil && contacts?.count ?? 0 > 0 {
                    List(contacts!) { contact in
                        NavigationLink(destination: ContactDetailView(contact: contact)) {
                                ContactRowView(contact: contact)
                            }
                    }.background(opacity(1))
                } else {
                    Text("")
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
                        AddContactButtonView(contact: $contacts)
                    }, trailing:
                    HStack{
                        LogOutButtonView(presentationMode: presentationMode)
                    })
            .onAppear(perform: {
                RESTController.getContacts(token: self.userToken.value ?? "", withCompletion: {resp in
                    if let response = resp {
                        self.contacts = response
                    } else {
                        self.contacts = nil
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
