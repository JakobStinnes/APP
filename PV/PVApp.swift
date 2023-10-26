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
    @State private var isAuthenticated = false  // State for authentication
    
    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
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
            } else {
                LoginView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}



