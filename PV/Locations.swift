//
//  Locations.swift
//  PV
//
//  Created by Jakob Stinnes on 19.10.23.
//

import Foundation

import Foundation

class Locations: ObservableObject {
    @Published var places: [Location] = []
    private var networkManager = NetworkManager()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        networkManager.fetchContacts { [weak self] locations in
            DispatchQueue.main.async {
                if let locations = locations {
                    self?.places = locations
                    print("Fetched \(locations.count) locations.")
                }
            }
        }
    }
}
