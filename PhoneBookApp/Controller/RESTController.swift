//
//  RESTController.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/18/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import Foundation

final class RESTController {
    
    static var token : String {
    get {
            UserDefaults.standard.string(forKey: "token") ?? ""
        }
    }
    
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
    
    static func logOutUser(withCompletion completion: @escaping (URLResponse?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let url = URL(string: "http://localhost:8080/userToken")!
        // create the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let _ = data else {
                completion(nil)
                return
            }
            completion(response)
        }
        task.resume()
    }
    
    static func getContacts(withCompletion completion: @escaping ([ContactResp]?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let url = URL(string: "http://localhost:8080/contacts")!

        // create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            let wrapper = try? JSONDecoder().decode([ContactResp].self, from: data)
            completion(wrapper)
        }
        task.resume()
    }
    
    static func addContact(contact: Contact, withCompletion completion: @escaping (ContactResp?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let url = URL(string: "http://localhost:8080/contacts")!
        // create the request
        
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(contact)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            let wrapper = try? JSONDecoder().decode(ContactResp.self, from: data)
            completion(wrapper)
        }
        task.resume()
    }
    
    static func changeImage(imageRequest: CreatePictureRequest, withCompletion completion: @escaping (URLResponse?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let url = URL(string: "http://localhost:8080/pictures")!
        // create the request
        
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(imageRequest)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let _ = data else {
                completion(nil)
                return
            }
            completion(response)
        }
        task.resume()
    }
    
    static func getImage(contactId: UUID, withCompletion completion: @escaping (PictureResponse?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let url = URL(string: "http://localhost:8080/picturesGet")!
        // create the request
        
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if contactId.description == "74112390-9FC7-42CA-8EF7-25DD1ECC5CB3" {
            print(contactId.description)
        }
        let pictureReq = PictureRequest(contactId: contactId)
        let jsonData = try! encoder.encode(pictureReq)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let wrapper = try? JSONDecoder().decode(PictureResponse.self, from: data)
            completion(wrapper)
        }
        task.resume()
    }

}
