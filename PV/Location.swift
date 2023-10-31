//
//  Location.swift
//  PV
//
//  Created by Jakob Stinnes on 19.10.23.
//

import Foundation

struct Location: Codable, Identifiable {
    let id: Int
    let vorname: String
    let name: String
    let straße: String
    let hausnummer: String
    let plz: String
    let stadt: String
    let email: String
    let telefon: String
    let latitude: Double
    let longitude: Double
    let projektstatus: String
    let comments: [Comment]
}

struct Comment: Codable, Identifiable {
    let id: Int
    let content: String
    let author: Int
    let created: String
}
