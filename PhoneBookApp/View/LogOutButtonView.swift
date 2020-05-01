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
    
    
    var body: some View {
        HStack {
            Button("Log Out") {
                RESTController.logOutUser(withCompletion: { resp in
                    if let response = resp {
                        if let httpResponse = response as? GenericResponse {
                            if httpResponse.statusCode == 200 {
                                UserDefaults.standard.set("", forKey: "token")
                                self.presentationMode?.wrappedValue.dismiss()
                            }
                        }
                    }
                })
            }.foregroundColor(.white)
        }
    }
}
