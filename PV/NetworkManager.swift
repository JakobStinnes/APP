//
//  NetworkManager.swift
//  PV
//
//  Created by Jakob Stinnes on 31.10.23.
//

import Foundation

class NetworkManager {
    
    func loginUser(username: String, password: String, otpToken: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: API.loginEndpoint) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyData = "username=\(username)&password=\(password)&otp_token=\(otpToken)"
        request.httpBody = bodyData.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data, let tokenResponse = try? JSONDecoder().decode(TokenResponse.self, from: data) {
                completion(tokenResponse.token)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func fetchContacts(token: String, completion: @escaping ([Location]?) -> Void) {
        guard let url = URL(string: API.contactsEndpoint) else {
            print("Invalid API URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Failed to fetch data:", error.localizedDescription)
                completion(nil)
                return
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
            } catch {
                print("Failed to decode data:", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
    
    // Later on, you can add more networking methods here like postComment, etc.
}

