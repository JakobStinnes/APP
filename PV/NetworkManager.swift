//
//  NetworkManager.swift
//  PV
//
//  Created by Jakob Stinnes on 31.10.23.
//

import Foundation

class NetworkManager {
    func fetchContacts(completion: @escaping ([Location]?) -> Void) {
        guard let url = URL(string: "http://192.168.178.153:8007/contacts/") else {
            print("Invalid API URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch data:", error.localizedDescription)
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code:", httpResponse.statusCode)
            }

            guard let data = data else {
                print("Data is nil")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode([Location].self, from: data)
                completion(decodedData)
            } catch let jsonError as DecodingError {
                switch jsonError {
                case .dataCorrupted(let context):
                    print("Data Corrupted: \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("Key Not Found: \(key.stringValue), \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("Type Mismatch: \(type), \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("Value Not Found: \(type), \(context.debugDescription)")
                default:
                    print("Failed to decode data:", jsonError.localizedDescription)
                }
                completion(nil)
            } catch {
                print("Failed to decode data:", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
}
