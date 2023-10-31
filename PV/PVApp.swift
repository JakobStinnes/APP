//
//  PVApp.swift
//  PV
//
//  Created by Jakob Stinnes on 19.10.23.
//

import SwiftUI

@main
struct PVApp: App {
    @StateObject private var locations = Locations()
    @AppStorage("userToken") var userToken: String? // Using AppStorage to listen to UserDefaults changes
    
    var body: some Scene {
        WindowGroup {
            if userToken == nil {
                LoginForm(token: $userToken, locations: locations)  // Pass the locations object
            } else {
                TabView {
                    NavigationView {
                        ContactView(locations: locations)
                    }
                    .tabItem {
                        Label("Contacts", systemImage: "person.crop.circle.fill")
                    }
                    NavigationView {
                        MapView()
                    }
                    .tabItem {
                        Label("Map", systemImage: "map.fill")
                    }
                }
                .environmentObject(locations)
            }
        }
    }
}
