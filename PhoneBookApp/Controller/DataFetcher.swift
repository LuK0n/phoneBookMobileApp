//
//  ContactsFetcher.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/27/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class DataFetcher: ObservableObject {
    
    static let shared : DataFetcher = DataFetcher()
    
    private init() {load()}
    
    func isNeedRefresh() -> Bool {
        if self.imageUpdated && self.addressUpdated && self.contactUpdated {
            return true
        }
        return false
    }
    
    var needRefresh : Bool = false {
        didSet {
            if isNeedRefresh() {
                if self.needRefresh == true {
                    objectWillChange.send()
                }
            } else {
                if self.needRefresh == true {
                    self.needRefresh = false
                }
            }
        }
    }
    var imageUpdated = false {
        didSet {
            if isNeedRefresh() {
                self.needRefresh = true
            }
        }
    }
    var addressUpdated = false {
        didSet {
            if isNeedRefresh() {
                self.needRefresh = true
            }
        }
    }
    var contactUpdated = false {
        didSet {
            if isNeedRefresh() {
                self.needRefresh = true
            }
        }
    }
    var contacts = [Contact]() {
        didSet {
            if oldValue.count > self.contacts.count {
                objectWillChange.send()
            }
        }
    }
    
     var addressMap = [UUID : Address]()
    
     var imageMap = [UUID : String]()
    
    func load() {
        self.imageUpdated = false
        self.addressUpdated = false
        self.contactUpdated = false
        self.needRefresh = false
        RESTController.getContacts(withCompletion: {resp in
            if case let responses as [Contact] = resp {
                    var contactsToRet = [Contact]()
                    var leftToProcess = responses.count
                    for response in responses {
                        contactsToRet.append(Contact(id: response.id, name: response.name, email: response.email, phoneNumber: response.phoneNumber, user: nil))
                        leftToProcess -= 1
                        if leftToProcess == 0 {
                            self.contacts = contactsToRet
                            self.contactUpdated = true
                        }
                    }
                    do {
                        var imagesMap = [UUID : String]()
                        var leftToProcess = responses.count
                        for response in responses {
                            RESTController.getImage(contactId: response.id, withCompletion: { resp in
                                if case let resp as PictureResponse = resp {
                                        imagesMap[response.id] = resp.url.path
                                    }
                                leftToProcess -= 1
                                if leftToProcess == 0 {
                                    self.imageMap = imagesMap
                                    self.imageUpdated = true
                                }
                            })
                        }
                    }
                    do {
                    var addressesMap = [UUID : Address]()
                    var leftToProcess = responses.count
                    for response in responses {
                        RESTController.getAddress(contactId: response.id, withCompletion: { resp in
                            if case let resp as Address = resp {
                                addressesMap[response.id] = resp
                            }
                            leftToProcess -= 1
                            if leftToProcess == 0 {
                                self.addressMap = addressesMap
                                self.addressUpdated = true
                            }
                        })
                    }
                }
            }
        })
    }
    
    func getImage(id: UUID) -> Image {
        return Image(uiImage: UIImage(contentsOfFile: self.imageMap[id] ?? "") ?? UIImage(named: "book")!)
    }
    
    func getAddress(id: UUID) -> Address {
        return self.addressMap[id] ?? Address(id: nil, street: "", city: "", zip: "", houseNr: "")
    }
}
