//
//  LoginForm.swift
//  PV
//
//  Created by Jakob Stinnes on 31.10.23.
//

import SwiftUI

struct LoginForm: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var otpToken: String = ""
    @Binding var token: String?
    @ObservedObject var locations: Locations  // Accept the locations object

    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.Padding.standard) {
                
                // Top bar with Logo and Title
                ZStack {
                    Text("Login")
                        .font(AppTheme.Fonts.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.primary)
                    
                    HStack {
                        Image(AppTheme.Icons.logo)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Spacer()
                    }
                    .padding(.horizontal, AppTheme.Padding.large)
                }
                .padding(.top, AppTheme.Padding.topLarge)
                
                // Rest of the login form
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                TextField("OTP Token", text: $otpToken)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                Button("Login", action: loginUser)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
    }

    func loginUser() {
        let url = URL(string: "http://192.168.178.24:8007/api/login/")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyData = "username=\(username)&password=\(password)&otp_token=\(otpToken)"
        request.httpBody = bodyData.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data, let tokenResponse = try? JSONDecoder().decode(TokenResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.token = tokenResponse.token
                    UserDefaults.standard.set(tokenResponse.token, forKey: "userToken")
                    
                    // Fetch data after successful login
                    self.locations.fetchData()
                }
            } else {
                print("Failed to log in")
            }
        }.resume()
    }
}

struct TokenResponse: Codable {
    var token: String
}
