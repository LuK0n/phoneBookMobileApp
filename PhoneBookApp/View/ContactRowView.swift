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
    
    @State var image : Image =  Image("book")
    
    var body: some View {
        HStack(alignment: .center) {
            image
            .resizable()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .clipped()
            .overlay(Circle().stroke(Color.white, lineWidth: 1))
            .padding(25)
            VStack {
                Text("\(contact.name)").bold().font(.system(size: 25))
                Text("\(contact.phoneNumber.formattedWithSeparator)").italic().font(.system(size: 20))
                Text("\(contact.email)").italic().font(.system(size: 20))
            }.foregroundColor(Color.white)
        }.onAppear(perform: {
            self.image = DataFetcher.shared.getImage(id: self.contact.id)
        })
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
        ContactRowView(contact: Contact(id: nil, name: "Mark Markov", email: "mail@server.com", phoneNumber: 0945648533, user: nil), image: Image("book"))
    }
}
#endif
