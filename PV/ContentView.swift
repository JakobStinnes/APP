//
//  ContentView.swift
//  PV
//
//  Created by Jakob Stinnes on 19.10.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locations: Locations
    @State private var searchText: String = ""
    
    private let mainColor: Color = .green
    private let secondaryColor: Color = Color(.secondarySystemBackground)
    
    var filteredLocations: [Location] {
        if searchText.isEmpty {
            return locations.places
        } else {
            return locations.places.filter { $0.name.contains(searchText) || $0.vorname.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Logo, Title and "+" button
                HStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Spacer()
                    Text("Contacts")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(mainColor)
                    Spacer()
                    Button(action: {
                        // Implement your add contact action here
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(mainColor)
                    }
                    .padding(.trailing, 10)
                }
                .padding(.horizontal, 30)
                .padding(.top, 60) // Additional top padding for the Logo, Title, and "+" button
                
                // Contacts list
                ScrollView {
                    // Search bar
                    TextField("Search by name...", text: $searchText)
                        .padding(10)
                        .background(secondaryColor)
                        .cornerRadius(10)
                        .padding(.horizontal, 15)
                        .padding(.bottom, 5)  // Padding below the search bar

                    LazyVStack(spacing: 0) { // Minimal spacing for a tighter look
                        ForEach(filteredLocations) { location in
                            NavigationLink(destination: ContactDetailsView(location: location)) {
                                HStack {
                                    Text("\(location.vorname) \(location.name)")
                                        .font(.system(size: 17))  // Default font for Apple contacts
                                        .foregroundColor(.primary)  // Default text color
                                    Spacer()
                                }
                                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))  // Apple-like padding
                            }
                            Divider()  // Separator between contact items
                        }
                    }
                    .background(Color.white)  // Set background to white for the list
                }
                .background(Color.white)  // Set background to white for the ScrollView
            }
            .padding(.top, 10) // Shift content downwards
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
        }
    }
}





struct ContactDetailsView: View {
    let location: Location
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Displaying the contact's name
                Text("\(location.vorname) \(location.name)")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .padding(.top, 20)
                
                // Actionable buttons for calling, mailing, and directions
                HStack(spacing: 40) {
                    Button(action: {
                        // Handle call action
                        // Typically: "tel:\(location.phoneNumber)"
                    }) {
                        VStack {
                            Image(systemName: "phone.fill")
                            Text("Call")
                        }
                    }

                    Button(action: {
                        // Handle mail action
                        // Typically: "mailto:\(location.email)"
                    }) {
                        VStack {
                            Image(systemName: "envelope.fill")
                            Text("Mail")
                        }
                    }

                    Button(action: {
                        // Handle direction action
                        // Typically: Use a map service with the address: "\(location.strasse) \(location.hausnummer)"
                    }) {
                        VStack {
                            Image(systemName: "arrow.right.arrow.left.circle.fill")
                            Text("Directions")
                        }
                    }
                }
                .font(.headline)
                .padding()

                // Contact's details as in Apple Contacts
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                        Label {
                            Text(location.email)
                        } icon: {
                            Image(systemName: "envelope.fill")
                        }
                        
                        Label {
                            Text(location.projektstatus)
                        } icon: {
                            Image(systemName: "doc.plaintext.fill")
                        }

                        Label {
                             Text("\(location.straße) \(location.hausnummer)")
                         } icon: {
                             Image(systemName: "house.fill")
                         }
                    }
                    .font(.headline)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    
                }
            }
            .padding()
        }
        .background(Color.white)
        .navigationBarTitle(location.name, displayMode: .inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(locations: Locations())
    }
}
