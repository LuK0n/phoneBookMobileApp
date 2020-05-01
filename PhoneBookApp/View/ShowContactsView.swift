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
    @ObservedObject var fetcher = DataFetcher.shared
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                List {
                    if self.fetcher.needRefresh {
                        ForEach(fetcher.contacts) { contact in
                                NavigationLink(destination: ContactDetailView(contact: contact)) {
                                    ContactRowView(contact: contact)
                                }
                        }.onDelete(perform: self.delete)
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
                    NavigationLink(destination: AddContactView()) {
                        Image(systemName: "plus")
                    }.foregroundColor(.white)
                }, trailing:
                HStack{
                    LogOutButtonView(presentationMode: presentationMode)
                })
        }.navigationBarTitle("")
        .navigationBarHidden(true)

    }
    
    func delete(at offsets: IndexSet) {
        let iterator = offsets.makeIterator()
        for (_,element) in iterator.enumerated() {
            RESTController.deleteContact(contactId: self.fetcher.contacts[element].id, withCompletion: { resp in
                if let httpResponse = resp as? GenericResponse {
                    if httpResponse.statusCode == 200 {
                        let imgUrl = self.fetcher.imageMap[self.fetcher.contacts[element].id]
                            let manager = FileManager.default
                            do {
                                try manager.removeItem(at: URL(string: imgUrl ?? "/")!)
                            } catch {
                                //Can be ignored!
                            }
                        self.fetcher.contacts.remove(atOffsets: offsets)
                    }
                }
            })
        }
    }
}

#if DEBUG
struct ShowContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowContactsView()
    }
}
#endif
