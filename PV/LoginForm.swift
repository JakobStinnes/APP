//
//  LoginForm.swift
//  PV
//
//  Created by Jakob Stinnes on 31.10.23.
//

import SwiftUI

struct LoginForm: View {
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
                
                // Remove the login form fields and button
                Button("Fetch Data", action: fetchData)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
    }

    // Modify the loginUser function to fetch data directly
    func fetchData() {
        self.token = "SampleToken"  // Set a sample token or leave it as nil
        UserDefaults.standard.set(self.token, forKey: "userToken")
        
        // Fetch data after successful "login" or data retrieval
        self.locations.fetchData()
    }
}
