//
//  ContactRowView.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/23/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import SwiftUI

struct ContactRowView: View {
    
    let contact : Contact
    
    @State var image : Image = Image("book")
    
    var body: some View {
        HStack(alignment: .center) {
            image
            .resizable()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .clipped()
            .overlay(Circle().stroke(Color.white, lineWidth: 1))
            .padding(25)
            .onAppear(perform: {
                RESTController.getImage(contactId: self.contact.id, withCompletion: { resp in
                    if case let resp as PictureResponse = resp {
                        Image(uiImage: (UIImage(contentsOfFile: "") ?? UIImage(named: "book")!))
                        print(resp.url.path)
                        self.image = Image(uiImage: UIImage(contentsOfFile: resp.url.path) ?? UIImage(named: "book")!)
                        }
                    }
                )
            })
            VStack {
                Text("\(contact.name)").bold().font(.system(size: 25))
                Text("0\(contact.phoneNumb.formattedWithSeparator)").italic().font(.system(size: 20))
                Text("\(contact.email)").italic().font(.system(size: 20))
            }.foregroundColor(Color.white)
        }
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

#if DEBUG
struct ContactRowView_Previews: PreviewProvider {
    static var previews: some View {
        ContactRowView(contact: Contact(id: nil, name: "Mark Markov", email: "mail@server.com", phoneNumber: 0945648533))
    }
}
#endif
