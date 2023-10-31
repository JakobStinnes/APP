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

    // Create an instance of NetworkManager
    private let networkManager = NetworkManager()

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
        networkManager.loginUser(username: username, password: password, otpToken: otpToken) { receivedToken in
            DispatchQueue.main.async {
                if let receivedToken = receivedToken {
                    self.token = receivedToken
                    UserDefaults.standard.set(receivedToken, forKey: "userToken")
                    
                    // Fetch data after successful login
                    self.locations.fetchData()
                } else {
                    print("Failed to log in")
                }
            }
        }
    }
}

struct TokenResponse: Codable {
    var token: String
}
