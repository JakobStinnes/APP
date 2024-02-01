//
//  Location.swift
//  PV
//
//  Created by Jakob Stinnes on 19.10.23.
//

import Foundation

struct Location: Codable, Identifiable {
    let kundenId: Int // Keep your backend identifier
    let vorname: String
    let name: String
    let strasse: String
    let hausnummer: String
    let plz: String
    let stadt: String
    let telefon: String
    let email: String
    let latitude: Double
    let longitude: Double
    let comments: [Comment]

    // Computed property to satisfy Identifiable protocol
    var id: Int { kundenId }
}


struct Comment: Codable, Identifiable {
    let id: Int
    let content: String
    let author: Int
    let authorname: String
    let created: String
}
