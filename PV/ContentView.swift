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
    @Environment(\.colorScheme) var colorScheme

    var filteredLocations: [Location] {
        if searchText.isEmpty {
            return locations.places
        } else {
            return locations.places.filter { $0.name.contains(searchText) || $0.vorname.contains(searchText) }
        }
    }

    var body: some View {
        VStack(spacing: 30) {
            // Top bar with Logo and Title
            ZStack {
                Text("Contacts")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.primary)

                HStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Spacer()
                    Button(action: {
                        // Implement your add contact action here
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(Color.primary)
                    }
                }
                .padding(.horizontal, 30)
            }
            .padding(.top, 60)

            // Contacts list
            ScrollView {
                // Search bar
                TextField("Search by name...", text: $searchText)
                    .padding(10)
                    .background(searchBarBackgroundColor)
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 5)

                LazyVStack(spacing: 0) {
                    ForEach(filteredLocations) { location in
                        NavigationLink(destination: ContactDetailsView(location: location)) {
                            HStack {
                                Text("\(location.vorname) \(location.name)")
                                    .font(.system(size: 17))
                                    .foregroundColor(Color.primary)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                        }
                        Divider()
                    }
                }
                .background(listBackgroundColor)
            }
            .background(scrollViewBackgroundColor)
        }
        .background(backgroundColor)
        .padding(.top, 10)
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }

    // Define background colors based on the color scheme
    var backgroundColor: Color {
        return colorScheme == .dark ? Color(UIColor.systemBackground) : Color.white
    }

    var searchBarBackgroundColor: Color {
        return colorScheme == .dark ? Color(UIColor.systemGray6) : Color(UIColor.systemGray6)
    }

    var listBackgroundColor: Color {
        return colorScheme == .dark ? Color(UIColor.systemGroupedBackground) : Color.white
    }

    var scrollViewBackgroundColor: Color {
        return colorScheme == .dark ? Color(UIColor.systemGroupedBackground) : Color.white
    }
}







struct ContactDetailsView: View {
    let location: Location
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Displaying the contact's name
                Text("\(location.vorname) \(location.name)")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .padding(.top, 20)
                    .foregroundColor(textColor)

                // Actionable buttons for calling, mailing, and directions
                HStack(spacing: 40) {
                    Button(action: {
                       
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
                        openMaps(for: location)
                    }) {
                        VStack {
                            Image(systemName: "arrow.right.arrow.left.circle.fill")
                            Text("Directions")
                        }
                    }
                }
                .font(.headline)
                .padding()
                .foregroundColor(textColor)

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
                    .background(backgroundViewColor)
                }
            }
            .padding()
        }
        .background(scrollViewBackgroundColor)
        .navigationBarTitle(location.name, displayMode: .inline)
    }

    var backgroundColor: Color {
        return colorScheme == .dark ? Color(UIColor.systemBackground) : Color.white
    }

    var backgroundViewColor: Color {
        return colorScheme == .dark ? Color.gray.opacity(0.1) : Color.gray.opacity(0.3)
    }

    var scrollViewBackgroundColor: Color {
        return colorScheme == .dark ? Color(UIColor.systemGroupedBackground) : Color.white
    }

    var textColor: Color {
        return colorScheme == .dark ? Color.white : Color.primary
    }
    func openMaps(for location: Location) {
        let addressString = "\(location.straße) \(location.hausnummer), \(location.plz) \(location.stadt)"
        let encodedAddress = addressString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let directionsURL = URL(string: "http://maps.apple.com/?address=\(encodedAddress)") {
            UIApplication.shared.open(directionsURL, options: [:], completionHandler: nil)
        }
    }
    func callNumber(telefon: String) {
            if let phoneCallURL = URL(string: "tel://\(telefon)"), UIApplication.shared.canOpenURL(phoneCallURL) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(locations: Locations())
    }
}
