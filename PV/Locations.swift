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
        guard let url = URL(string: "http://192.168.178.86:8007/api/contacts/") else {
            fatalError("Invalid API URL")
        }
        
        var request = URLRequest(url: url)
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                fatalError("Failed to fetch data: \(error?.localizedDescription ?? "")")
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode([Location].self, from: data)
                DispatchQueue.main.async {
                    self?.places = decodedData
                }
            } catch {
                fatalError("Failed to decode data: \(error.localizedDescription)")
            }
        }.resume()
    }
}
