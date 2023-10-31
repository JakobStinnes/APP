//
//  Locations.swift
//  PV
//
//  Created by Jakob Stinnes on 19.10.23.
//

import Foundation

class Locations: ObservableObject {
    @Published var places: [Location] = []
    
    var primary: Location {
        places[0]
    }
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        guard let url = URL(string: "http://192.168.178.24:8007/api/contacts/") else {
            print("Invalid API URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        // Check if token exists in UserDefaults
        if let userToken = UserDefaults.standard.string(forKey: "userToken") {
            request.addValue("Token \(userToken)", forHTTPHeaderField: "Authorization")
        } else {
            print("User is not logged in or token is missing")
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                print("Failed to fetch data:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("Data is nil")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode([Location].self, from: data)
                DispatchQueue.main.async {
                    self?.places = decodedData
                }
            } catch {
                print("Failed to decode data:", error.localizedDescription)
            }
        }.resume()
    }
}
