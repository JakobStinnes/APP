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
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    ContentView(locations: locations)
                }
                .tabItem {
                    Label("Contacts", systemImage: "person.crop.circle.fill")
                }
                NavigationView {
                    WorldView()
                }
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
            }
            .environmentObject(locations)
        }
    }
}


