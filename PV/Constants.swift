//
//  Constants.swift
//  PV
//
//  Created by Jakob Stinnes on 31.10.23.
//

import Foundation
struct API {
    static let baseURL = "http://192.168.178.86:8007/api/"
    static let contactsEndpoint = "\(baseURL)contacts/"
    static let loginEndpoint = "\(baseURL)login/"
}

struct UserKeys {
    static let userToken = "userToken"
}

// Add more constants as your app grows
