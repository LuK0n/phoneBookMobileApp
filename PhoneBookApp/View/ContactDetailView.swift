//
//  ContactDetail.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/23/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import SwiftUI
import Combine

struct ContactDetailView: View {
    
    @State var phoneNumber = "init"
    @State var showingPicker = false
    @State var showAction: Bool = false
    @State var originImage : Image = Image("book")
    @State var image : Image = Image("book")
    
    @State var contact : Contact
    @State var address : Address = Address(id: nil, street: "", city: "", zip: "", houseNr: "")
    
    var formatter : NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimum = 1
        return formatter
    }
    
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var userToken : UserToken
    
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
                    ImagePicker.shared.name = nil
                })
            ])
    }
    
    var body: some View {
        VStack(alignment: .center) {
                image
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 2.0, x: 5, y: 2)
                .onTapGesture {
                    self.showAction = true
                }
                Divider()
                VStack(alignment: .center, spacing: 15) {
                    TextField("Name", text: self.$contact.name)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    TextField("Email", text: self.$contact.email)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    TextField("Phone Number", text: self.$phoneNumber)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    .keyboardType(.numberPad)
                    .onReceive(Just(phoneNumber)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if newValue == "init" {
                            return
                        }
                        if filtered != newValue {
                            self.phoneNumber = filtered
                        }
                        self.contact.phoneNumber = Int(self.phoneNumber) ?? 0
                    }
                Divider()
                    TextField("Street", text: self.$address.street)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    TextField("City", text: self.$address.city)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    TextField("Zip", text: self.$address.zip)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    TextField("House Nr.", text: self.$address.houseNr)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    HStack() {
                        Button(action: {
                            self.updateFields()
                        }) {
                            Text("Update contact")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(15.0)
                                .shadow(radius: 10.0, x: 20, y: 10)
                        }
                        Spacer()
                        Button(action: {
                            RESTController.deleteAddress(addressId: self.address.id, withCompletion: { resp in
                                if case let resp as GenericResponse = resp {
                                    self.address = Address(id: nil, street: "", city: "", zip: "", houseNr: "")
                                    DataFetcher.shared.addressMap.removeValue(forKey: self.address.id)
                                }
                            })
                        }) {
                            Text("Delete address")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(15.0)
                                .shadow(radius: 10.0, x: 20, y: 10)
                        }
                    }
                }
            Spacer()
            }.background(
            LinearGradient(gradient: Gradient(colors:[.purple,.blue]), startPoint: .top, endPoint:.bottom).scaledToFill()
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
        }.onDisappear(perform: {
            ImagePicker.shared.image = nil
        })
        .onAppear(perform: {
            self.phoneNumber = String(self.contact.phoneNumber)
            self.image = DataFetcher.shared.getImage(id: self.contact.id)
            self.originImage = self.image
            self.address = DataFetcher.shared.getAddress(id: self.contact.id)
        })
    }
    
    func updateFields() {
        let addressRequest = CreateAddressRequest(street: self.address.street, city: self.address.city, zip: self.address.zip, houseNr: self.address.houseNr, contactId: self.contact.id)
        RESTController.postAddress(addressRequest: addressRequest, withCompletion: { resp in
        })
        RESTController.updateContact(contact: self.contact, withCompletion: { resp in
        })
        
        if self.originImage == self.image {
            return
        }
        RESTController.changeImage(imageRequest: CreatePictureRequest(url: (ImagePicker.shared.name ?? URL(string: "book"))!, contactId: self.contact.id), withCompletion: { resp in
            DataFetcher.shared.load()
        })
    }
}

#if DEBUG
struct ContactDetail_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailView(image: Image("book"), contact: Contact(id: nil, name: "Mark Markov", email: "mail@server.com", phoneNumber: 0945648533, user: nil), address: Address(id: nil, street: "street", city: "city", zip: "zuo", houseNr: "house"))
    }
}
#endif
