//
//  ShowContactsView.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/21/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import SwiftUI
import Combine

struct ShowContactsView: View {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userToken : UserToken
    @ObservedObject var fetcher = ContactsFetcher()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                List(fetcher.contacts) { contact in
                        NavigationLink(destination: ContactDetailView(contact: contact)) {
                                ContactRowView(contact: contact)
                        }
                    }
                Spacer()
            }.onAppear(perform: fetcher.load)
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
