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
    
    var body: some View {
        NavigationView {
            VStack {
            Spacer()
                Text("Hello")
            Spacer()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.purple,.blue]), startPoint: .top, endPoint: .bottom).scaledToFill()
                    .edgesIgnoringSafeArea(.all))
            }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing:
            HStack {
                Button("Log Out") {
                    RESTController.logOutUser(token: self.userToken.value ?? "", withCompletion: { resp in
                        if let response = resp {
                            if let httpResponse = response as? HTTPURLResponse {
                                if httpResponse.statusCode == 200 {
                                    self.userToken.value = nil
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    })
                }.foregroundColor(.white)
            }
        )
    }
}

struct ShowContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowContactsView()
    }
}
