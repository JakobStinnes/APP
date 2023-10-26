//
//  ContactView.swift
//  PV
//
//  Created by Jakob Stinnes on 19.10.23.
//

import SwiftUI
import MapKit


struct ContactView: View {
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
        return colorScheme == .dark ? Color(UIColor.systemBackground) : Color.white
    }

    var scrollViewBackgroundColor: Color {
        return colorScheme == .dark ? Color(UIColor.systemBackground) : Color.white
    }
}


func convertDate(from dateString: String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSxxx"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    guard let date = inputFormatter.date(from: dateString) else { return nil }

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd.MM.yy, HH:mm 'h'"

    return outputFormatter.string(from: date)
}


struct CommentSection: View {
    let comments: [Comment]
    @State private var isExpanded: Bool = false
    @Environment(\.colorScheme) var colorScheme

    var shadowColor: Color {
        switch colorScheme {
        case .dark:
            return Color.white.opacity(0.05)
        default:
            return Color.black.opacity(0.07)
        }
    }
    
    let authorDictionary: [Int: String] = [
        1: "Jakob Stinnes",
        2: "Jakob Moecke",
    ]

    var body: some View {
            VStack(alignment: .leading) {
                DisclosureGroup(
                    isExpanded: $isExpanded,
                    content: {
                        ForEach(comments) { comment in
                            VStack(alignment: .leading, spacing: 8) {
                                if let authorName = authorDictionary[comment.author] {
                                    Text(authorName)
                                        .font(.subheadline)
                                        .fontWeight(.bold)  // Bold for author names
                                        .foregroundColor(Color.blue)
                                }
                                
                                Text(comment.content)
                                
                                HStack {
                                    Spacer()
                                    if let formattedDate = convertDate(from: comment.created) {
                                        Text(formattedDate)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .fontWeight(.regular)  // Regular for dates
                                    }
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemBackground)).shadow(color: shadowColor, radius: 5, x: 0, y: 2))
                            .padding(.vertical, 4)
                        }
                    },
                    label: {
                        HStack {
                            Text("Comments (\(comments.count))")
                                .font(.headline)
                            Spacer()
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .resizable()
                                .frame(width: 13, height: 7)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemBackground)).shadow(color: shadowColor, radius: 5, x: 0, y: 2))  // Made corner radius consistent
                    }
                )
            }
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .padding()
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
        }
    }

struct ContactDetailsView: View {
    let location: Location
    @Environment(\.colorScheme) var colorScheme
    @State var mapRegion: MKCoordinateRegion
    
    var shadowColor: Color {
        switch colorScheme {
        case .dark:
            return Color.white.opacity(0.05)
        default:
            return Color.black.opacity(0.07)
        }
    }

    init(location: Location) {
        self.location = location
        _mapRegion = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Adjust span as needed
        ))
    }

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
                        callNumber(telefon: location.telefon)
                    }) {
                        VStack {
                            Image(systemName: "phone.fill")
                            Text("Call")
                        }
                    }

                    Button(action: {
                        sendEmail(email: location.email)
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
                .padding(.bottom, 10)

                // Contact's details
                Group {
                    InformationRow(icon: "house.fill", text: "\(location.straße) \(location.hausnummer)")
                    InformationRow(icon: "map.fill", text: "\(location.plz) \(location.stadt)")
                    InformationRow(icon: "phone.fill", text: location.telefon)
                    InformationRow(icon: "envelope.fill", text: location.email)
                    InformationRow(icon: "doc.plaintext.fill", text: location.projektstatus)
                }
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: shadowColor, radius: 5, x: 0, y: 2)
                .padding(.bottom, 10)

                Button(action: {
                    openMaps(for: location)
                }) {
                    Map(coordinateRegion: $mapRegion, annotationItems: [location]) { location in
                        MapPin(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), tint: .blue)
                    }
                    .frame(height: 150)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                    )
                }
                .padding(.bottom, 10)
                CommentSection(comments: location.comments)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(color: shadowColor, radius: 5, x: 0, y: 2)
                            .padding(.bottom, 20)
            }
            .padding(10)
        }
        .navigationBarTitle(location.name, displayMode: .inline)
    }





    // Extracted for reuse
    func detailItem(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
            Text(title)
        }
        .padding()
        .background(backgroundViewColor)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .frame(maxWidth: .infinity, alignment: .leading) // Makes it full width
    }

    var backgroundColor: Color {
        return colorScheme == .dark ? Color(UIColor.systemBackground) : Color.white
    }

    var backgroundViewColor: Color {
        return Color.red
    }


    var scrollViewBackgroundColor: Color {
        return colorScheme == .dark ? Color(UIColor.systemBackground) : Color.white
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
    func sendEmail(email: String) {
        if let emailURL = URL(string: "mailto:\(email)") {
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL)
            }
        }
    }
}

struct InformationRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .padding(.leading, 10)
            Text(text)
                .padding(.trailing, 10)
            Spacer()
        }
        .padding(.vertical, 5)  // Reduced vertical padding
    }
}


struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(locations: Locations())
    }
}
