//
//  AddContactView.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/26/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import SwiftUI
import Combine

struct AddContactView: View {

    @State var name = ""
    @State var email = ""
    @State var phoneNumber = ""
    
    @State var showingPicker = false
    @State var showAction: Bool = false
    @State var didSet: Bool = false

    @State var image : Image = Image("book")
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var sheet : ActionSheet {
        ActionSheet(
            title: Text("Action"),
            message: Text("What do you wants to do with the contact picture?"),
            buttons: [
                .default(Text("Change"), action: {
                    self.showAction = false
                    self.showingPicker = true
                }),
                .cancel(Text("Close"), action: {
                    self.showAction = false
                }),
                .destructive(Text("Remove"), action: {
                    self.showAction = false
                    self.image = Image("book")
                    ImagePicker.shared.image = nil
                })
            ])
    }

    var body: some View {
        VStack {
            self.image
            .resizable()
            .frame(width: 250, height: 250)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10.0, x: 20, y: 10)
            .padding(.bottom, 50)
            .onTapGesture {
                self.showAction = true
            }
            VStack(alignment: .leading, spacing: 15) {
                TextField("Name", text: self.$name)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                TextField("Email", text: self.$email)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                TextField("Phone number", text: self.$phoneNumber)
                .padding()
                .background(Color.themeTextField)
                .cornerRadius(20.0)
                .shadow(radius: 10.0, x: 20, y: 10)
                .keyboardType(.numberPad)
                    .onReceive(Just(phoneNumber)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.phoneNumber = filtered
                        }
                }
            }.padding([.leading, .trailing], 27.5)
            
            Button(action: {
                let contact = Contact(id: nil, name: self.name, email: self.email, phoneNumber: Int(self.phoneNumber) ?? 0, user: nil)
                RESTController.addContact(contact: contact, withCompletion: { resp in
                     if case let resp as Contact = resp {
                        RESTController.changeImage(imageRequest: CreatePictureRequest(url: (ImagePicker.shared.name ?? URL(string: "book"))!, contactId: resp.id), withCompletion: { imageResp in
                            ImagePicker.shared.image = nil
                            self.mode.wrappedValue.dismiss()
                        })
                     }
                 })
             }) {
                 Text("Add contact")
                     .font(.headline)
                     .foregroundColor(.white)
                     .padding()
                     .frame(width: 300, height: 50)
                     .background(Color.green)
                     .cornerRadius(15.0)
                     .shadow(radius: 10.0, x: 20, y: 10)
             }.padding(.top, 50)
            
            
            Spacer()
        }.background(
        LinearGradient(gradient: Gradient(colors: [.purple,.blue]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all))
        .sheet(isPresented: self.$showingPicker,
                onDismiss: {
                }, content: {
                    ImagePicker.shared.view
                })
        .onReceive(ImagePicker.shared.$image) { image in
            self.image = Image(uiImage: image ?? UIImage(named: "book")!)
        }
        .actionSheet(isPresented: $showAction) {
            sheet
        }
    }
}

struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactView(image: Image("book"))
    }
}


