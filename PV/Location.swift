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

    enum CodingKeys: String, CodingKey {
        case id
        case vorname
        case name
        case straße
        case hausnummer
        case plz
        case stadt
        case email
        case telefon
        case latitude
        case longitude
        case projektstatus
    }
}
