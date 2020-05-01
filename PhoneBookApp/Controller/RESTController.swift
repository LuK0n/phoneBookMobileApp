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
    
    static func makeRestCall<A: Codable,R: Codable>(requestData: A?, endPoint: Endpoint, method: HTTPMethod, withCompletion completion: @escaping (R?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let url = URL(string: "http://localhost:8080/\(endPoint.rawValue)")!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let requestData = requestData {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try! encoder.encode(requestData)
            request.httpBody = jsonData
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            let wrapper = try? JSONDecoder().decode(R.self, from: data)
            if let wrapper = wrapper {
                completion(wrapper)
            } else {
                completion(nil)
            }
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
    
    static func createUser<A: Codable,R: Codable>(requestData: A, withCompletion completion: @escaping (R?) -> Void) {
        return makeRestCall(requestData: requestData, endPoint: .users, method: .POST, withCompletion: completion)
    }
    
    static func logOutUser(withCompletion completion: @escaping (GenericResponse?) -> Void) {
        return makeRestCall(requestData: Optional<String>.none, endPoint: .userToken, method: .DELETE, withCompletion: completion.self)
    }
    
    static func getContacts(withCompletion completion: @escaping ([Contact]?) -> Void) {
        return makeRestCall(requestData: Optional<String>.none, endPoint: .contacts, method: .GET, withCompletion: completion)
    }
    
    static func addContact(contact: Contact, withCompletion completion: @escaping (Contact?) -> Void) {
        return makeRestCall(requestData: contact, endPoint: .contacts, method: .POST, withCompletion: completion.self)
    }
    
    static func changeImage(imageRequest: CreatePictureRequest, withCompletion completion: @escaping (PictureResponse?) -> Void) {
        return makeRestCall(requestData: imageRequest, endPoint: .pictures, method: .POST, withCompletion: completion)
    }
    
    static func getImage(contactId: UUID, withCompletion completion: @escaping (PictureResponse?) -> Void) {
        return makeRestCall(requestData: ContactModifyRequest(contactId: contactId), endPoint: .picturesGet, method: .POST, withCompletion: completion.self)
    }
    
    static func deleteContact(contactId: UUID, withCompletion completion: @escaping (GenericResponse?) -> Void) {
        return makeRestCall(requestData: ContactModifyRequest(contactId: contactId), endPoint: .contacts, method: .DELETE, withCompletion: completion.self)
    }
    
    static func getAddress(contactId: UUID, withCompletion completion: @escaping (Address?) -> Void) {
        return makeRestCall(requestData: ContactModifyRequest(contactId: contactId), endPoint: .addressesGet, method: .POST, withCompletion: completion.self)
    }
    
    static func postAddress(addressRequest: CreateAddressRequest, withCompletion completion: @escaping (Address?) -> Void) {
        return makeRestCall(requestData: addressRequest, endPoint: .addresses, method: .POST, withCompletion: completion.self)
    }
    
    static func deleteAddress(addressId: UUID, withCompletion completion: @escaping (GenericResponse?) -> Void) {
        return makeRestCall(requestData: DeleteAddressRequest(addressId: addressId), endPoint: .addresses, method: .DELETE, withCompletion: completion.self)
    }
    
    static func updateContact(contact: Contact, withCompletion completion: @escaping (Contact?) -> Void) {
        return makeRestCall(requestData: contact, endPoint: .contactsUpdate, method: .POST, withCompletion: completion)
    }

}
