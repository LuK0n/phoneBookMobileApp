//
//  RESTController.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/18/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import Foundation

final class RESTController {
    static func createUser(requestData: CreateUserRequest, withCompletion completion: @escaping (UserResponse?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let url = URL(string: "http://localhost:8080/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(requestData)
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            let wrapper = try? JSONDecoder().decode(UserResponse.self, from: data)
            completion(wrapper)
        }
        task.resume()
    }
    
    static func logInUser(username: String, password: String, withCompletion completion: @escaping (UserTokenResponse?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let url = URL(string: "http://localhost:8080/login")!
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        // create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            let wrapper = try? JSONDecoder().decode(UserTokenResponse.self, from: data)
            completion(wrapper)
        }
        task.resume()
    }
    
    static func logOutUser(token: String, withCompletion completion: @escaping (URLResponse?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let url = URL(string: "http://localhost:8080/userToken")!
        let tokenData = token.data(using: String.Encoding.utf8)!
//        let base64LoginString = tokenData.base64EncodedString()
        
//        var sessionConfig = URLSessionConfiguration.default
//        var authValue: String? = "Bearer \(tokenData)"
//        session.configuration.httpAdditionalHeaders = ["Authorization": authValue ?? ""]
        // create the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(response)
        }
        task.resume()
    }

}
