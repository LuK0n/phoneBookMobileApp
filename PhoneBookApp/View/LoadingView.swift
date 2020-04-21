//
//  ContentView.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/18/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
        // MARK: - Propertiers
    @State private var email = ""
    @State private var password = ""
    @State private var wrongAttempt = false
    
    var userRequest : CreateUserRequest { get {
        return CreateUserRequest(name: "someName", email: self.email, password: self.password, verifyPassword: self.password)
        }
    }
    
    @State var authenticationDidFail: Bool = false
    @State var authenticationDidSucceed: Bool = false
    
    @EnvironmentObject var userToken : UserToken
    
    var body: some View {
        NavigationView {
        VStack {
            Text("Phone Book App")
                .font(.largeTitle).foregroundColor(Color.white)
                .padding(.bottom, 40)
                .padding(.top, -40)
                .shadow(radius: 10.0, x: 20, y: 10)
            
            Image("book")
                .resizable()
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10.0, x: 20, y: 10)
                .padding(.bottom, 50)
            
            VStack(alignment: .leading, spacing: 15) {
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
                }.padding([.leading, .trailing], 27.5)
            
            if authenticationDidFail {
                Text("Information not correct. Try again.")
                    .offset(y: -10)
                    .foregroundColor(.red)
            }
            if authenticationDidSucceed == false {
                Button(action: {RESTController.logInUser(username: self.email, password: self.password, withCompletion: { resp in
                    if let response = resp {
                            self.authenticationDidFail = false
                            self.authenticationDidSucceed = true
                        self.userToken.value = (response as UserTokenResponse).value
                        } else {
                            self.wrongAttempt.toggle()
                            self.authenticationDidFail = true
                            self.authenticationDidSucceed = false
                        }
                    })}) {
                    Text("Sign In")
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
            } else {
                Text("Login succeeded!")
                        .font(.headline)
                        .frame(width: 250, height: 80)
                        .background(Color.green)
                        .cornerRadius(20.0)
                        .foregroundColor(.white)
                        .animation(Animation.default)
                NavigationLink("", destination: ShowContactsView(), isActive: $authenticationDidSucceed)
                    .navigationBarBackButtonHidden(true)
                
            }
            
            Spacer()
            HStack(spacing: 0) {
                Text("Don't have an account? ")
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .foregroundColor(.black)
                    }
                .navigationBarHidden(true)
            }
        }
        .onAppear(perform: {
            self.email = ""
            self.password = ""
        })
        .background(
            LinearGradient(gradient: Gradient(colors: [.purple,.blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))
        }.navigationBarHidden(true)
        .navigationBarTitle("")
    }
}

extension Color {
    static var themeTextField: Color {
        return Color(red: 120.0/255.0, green: 130.0/155.0, blue: 130.0/155.0, opacity: 1.0)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
#endif
