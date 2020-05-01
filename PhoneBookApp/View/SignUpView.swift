//
//  SignUpView.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/20/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var verifyPass = ""
    @State var wrongAttempt = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
        
    var userRequest : CreateUserRequest { get {
        return CreateUserRequest(name: "someName", email: self.email, password: self.password, verifyPassword: self.password)
        }
    }
        
    var body: some View {
        VStack {
            Image("book")
                .resizable()
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10.0, x: 20, y: 10)
                .padding(.bottom, 50)
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
                    
                SecureField("Password", text: self.$password)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                SecureField("Verify password", text: self.$verifyPass)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding([.leading, .trailing], 27.5)
                
            Button(action: {
                RESTController.createUser(requestData: CreateUserRequest(name: self.name, email: self.email, password: self.password, verifyPassword: self.verifyPass), withCompletion: { (resp : UserResponse?) in
                    if case let resp as UserResponse = resp {
                        self.mode.wrappedValue.dismiss()
                    } else {
                        self.wrongAttempt.toggle()
                    }
                })
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    .offset(x: self.wrongAttempt ? -10 : 0)
                    .animation(Animation.default.repeatCount(5).speed(5.0))
            }.padding(.top, 50)
                
            Spacer()
        }
        .background(
        LinearGradient(gradient: Gradient(colors: [.purple,.blue]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all))
    }
}

#if DEBUG
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
#endif
