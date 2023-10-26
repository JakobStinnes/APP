//
//  LoginView.swift
//  PV
//
//  Created by Jakob Stinnes on 26.10.23.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var otpToken: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Top bar with Logo and Title
                ZStack {
                    Text("Login")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.primary)  // center on the screen

                    HStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.top, 60)

                // Login Fields
                VStack(spacing: 20) {
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                    TextField("OTP Token", text: $otpToken)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .keyboardType(.numberPad)

                    Button(action: {
                        loginUser()
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 30)

                Spacer()
            }
            .background(Color(.systemBackground))  // Use the system background color which adapts to light/dark mode
        }
    }

    func loginUser() {
        let loginURL = URL(string: "http://192.168.178.86:8007/api/login/")!
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["username": username, "password": password, "otp_token": otpToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error during login: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let token = jsonResponse["token"] as? String {
                    // Save token for future use
                    UserDefaults.standard.setValue(token, forKey: "userToken")
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                } else {
                    print("Failed to get token from response.")
                }
            } catch {
                print("Error decoding JSON response: \(error)")
            }
        }.resume()
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isAuthenticated: .constant(false))
    }
}
