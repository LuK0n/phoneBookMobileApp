//
//  LogOutButtonView.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/23/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import SwiftUI

struct LogOutButtonView: View {
    
    var presentationMode: Binding<PresentationMode>?
    @EnvironmentObject var userToken : UserToken
    
    
    var body: some View {
        HStack {
            Button("Log Out") {
                RESTController.logOutUser(token: self.userToken.value ?? "", withCompletion: { resp in
                    if let response = resp {
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 200 {
                                self.userToken.value = nil
                                self.presentationMode?.wrappedValue.dismiss()
                            }
                        }
                    }
                })
            }.foregroundColor(.white)
        }
    }
}
