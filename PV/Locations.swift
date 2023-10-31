//
//  Locations.swift
//  PV
//
//  Created by Jakob Stinnes on 19.10.23.
//

import Foundation

class Locations: ObservableObject {
    @Published var places: [Location] = []
    private var networkManager = NetworkManager()  // Initialize the NetworkManager
    
    var primary: Location {
        places[0]
    }
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        if let userToken = UserDefaults.standard.string(forKey: UserKeys.userToken) {
            networkManager.fetchContacts(token: userToken) { [weak self] locations in
                DispatchQueue.main.async {
                    if let locations = locations {
                        self?.places = locations
                    }
                }
            }
        } else {
            print("User is not logged in or token is missing")
        }
    }
}
