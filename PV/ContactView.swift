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
        VStack(spacing: AppTheme.Padding.standard) {
            // Top bar with Logo and Title
            ZStack {
                Text("Contacts")
                    .font(AppTheme.Fonts.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(AppTheme.Colors.textColor(for: colorScheme))

                HStack {
                    Image(AppTheme.Icons.logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Spacer()
                    Button(action: {
                        // Implement your add contact action here
                    }) {
                        Image(systemName: AppTheme.Icons.plus)
                            .foregroundColor(AppTheme.Colors.textColor(for: colorScheme))
                    }
                }
                .padding(.horizontal, AppTheme.Padding.large)
            }
            .padding(.top, AppTheme.Padding.topLarge)

            // Contacts list
            ScrollView {
                // Search bar
                TextField("Search by name...", text: $searchText)
                    .padding(AppTheme.Padding.standard)
                    .background(AppTheme.Colors.searchBarBackground(for: colorScheme))
                    .cornerRadius(10)
                    .padding(.horizontal, AppTheme.Padding.standard)
                    .padding(.bottom, AppTheme.Padding.bottomSmall)

                LazyVStack(spacing: 0) {
                    ForEach(filteredLocations) { location in
                        NavigationLink(destination: ContactDetailsView(location: location)) {
                            HStack {
                                Text("\(location.vorname) \(location.name)")
                                    .font(AppTheme.Fonts.body)
                                    .foregroundColor(AppTheme.Colors.textColor(for: colorScheme))
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 10, leading: AppTheme.Padding.standard, bottom: 10, trailing: AppTheme.Padding.standard))
                        }
                        Divider()
                    }
                }
                .background(AppTheme.Colors.listBackground(for: colorScheme))
            }
            .background(AppTheme.Colors.scrollViewBackground(for: colorScheme))
        }
        .background(AppTheme.Colors.background(for: colorScheme))
        .padding(.top, AppTheme.Padding.standard)
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }
}


struct CommentSection: View {
    let comments: [Comment]
    @State private var isExpanded: Bool = false
    @Environment(\.colorScheme) var colorScheme

    var shadowColor: Color {
        switch colorScheme {
        case .dark:
            return AppTheme.Colors.shadowColor(for: .dark)
        default:
            return AppTheme.Colors.shadowColor(for: .light)
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
                            VStack(alignment: .leading, spacing: AppTheme.Padding.standard) {
                                if let authorName = authorDictionary[comment.author] {
                                    Text(authorName)
                                        .font(AppTheme.Fonts.commentAuthor)
                                        .foregroundColor(AppTheme.Colors.commentAuthorText)
                                        .fontWeight(.bold)
                                    
                                }
                                
                                Text(comment.content)
                                    .font(AppTheme.Fonts.commentContent)
                                    .foregroundColor(AppTheme.Colors.commentContentText)
                                
                                HStack {
                                    Spacer()
                                    if let formattedDate = AppTheme.convertDate(from: comment.created) {
                                        Text(formattedDate)
                                            .font(AppTheme.Fonts.commentDate)
                                            .foregroundColor(AppTheme.Colors.commentDateText)
                                    }
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(AppTheme.Colors.commentBackground).shadow(color: shadowColor, radius: 5, x: 0, y: 2))
                            .padding(.vertical, 4)
                        }
                    },
                    label: {
                        HStack {
                            Text("Comments (\(comments.count))")
                                .font(AppTheme.Fonts.title2)
                            Spacer()
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .resizable()
                                .frame(width: 13, height: 7)
                                .foregroundColor(AppTheme.Colors.commentDateText)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(AppTheme.Colors.commentBackground).shadow(color: shadowColor, radius: 5, x: 0, y: 2))  // Made corner radius consistent
                    }
                )
            }
            .background(AppTheme.Colors.background(for: colorScheme))
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
    
    // Define shadowColor using AppTheme
    var shadowColor: Color {
        return AppTheme.Colors.shadowColor(for: colorScheme)
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
                    .font(AppTheme.Fonts.title1) // Use AppTheme font
                    .fontWeight(.medium)
                    .padding(.top, AppTheme.Padding.standard) // Use AppTheme padding

                // Actionable buttons for calling, mailing, and directions
                HStack(spacing: AppTheme.Padding.large) { // Use AppTheme padding
                    Button(action: {
                        callNumber(telefon: location.telefon)
                    }) {
                        VStack {
                            Image(systemName: AppTheme.Icons.phoneFill) // Use AppTheme icon
                            Text("Call")
                        }
                    }

                    Button(action: {
                        sendEmail(email: location.email)
                    }) {
                        VStack {
                            Image(systemName: AppTheme.Icons.envelopeFill) // Use AppTheme icon
                            Text("Mail")
                        }
                    }

                    Button(action: {
                        openMaps(for: location)
                    }) {
                        VStack {
                            Image(systemName: AppTheme.Icons.arrowRightArrowLeftCircleFill) // Use AppTheme icon
                            Text("Directions")
                        }
                    }
                }
                .font(AppTheme.Fonts.headline) // Use AppTheme font
                .padding(.bottom, AppTheme.Padding.bottomSmall) // Use AppTheme padding

                // Contact's details
                Group {
                    InformationRow(icon: "house.fill", text: "\(location.straße) \(location.hausnummer)")
                    InformationRow(icon: "map.fill", text: "\(location.plz) \(location.stadt)")
                    InformationRow(icon: "phone.fill", text: location.telefon)
                    InformationRow(icon: "envelope.fill", text: location.email)
                    InformationRow(icon: "doc.plaintext.fill", text: location.projektstatus)
                }
                .background(AppTheme.Colors.listBackground(for: colorScheme)) // Use AppTheme color
                .cornerRadius(AppTheme.Padding.standard) // Use AppTheme padding
                .shadow(color: shadowColor, radius: 5, x: 0, y: 2)

                Button(action: {
                    openMaps(for: location)
                }) {
                    Map(coordinateRegion: $mapRegion, annotationItems: [location]) { location in
                        MapPin(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), tint: AppTheme.Colors.buttonBlue(for: colorScheme)) // Use AppTheme color
                    }
                    .frame(height: 150)
                    .cornerRadius(AppTheme.Padding.standard) // Use AppTheme padding
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Padding.standard) // Use AppTheme padding
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                    )
                }
                .padding(.bottom, AppTheme.Padding.bottomSmall) // Use AppTheme padding

                CommentSection(comments: location.comments)
                    .background(AppTheme.Colors.commentBackground) // Use AppTheme color
                    .cornerRadius(AppTheme.Padding.standard) // Use AppTheme padding
                    .shadow(color: shadowColor, radius: 5, x: 0, y: 2)
                    .padding(.bottom, AppTheme.Padding.large) // Use AppTheme padding
            }
            .padding(AppTheme.Padding.standard) // Use AppTheme padding
        }
        .navigationBarTitle(location.name, displayMode: .inline)
    }


    // Extracted for reuse
    func detailItem(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
            Text(title)
                .font(AppTheme.Fonts.body)
        }
        .padding()
        .cornerRadius(10)
        .shadow(color: AppTheme.Colors.shadowColor(for: colorScheme), radius: 5, x: 0, y: 2)
        .frame(maxWidth: .infinity, alignment: .leading)
    }


    var backgroundColor: Color {
        return AppTheme.Colors.background(for: colorScheme)
    }

    var scrollViewBackgroundColor: Color {
        return AppTheme.Colors.scrollViewBackground(for: colorScheme)
    }

    var textColor: Color {
        return AppTheme.Colors.textColor(for: colorScheme)
    }

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

struct InformationRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .padding(.leading, AppTheme.Padding.standard)
            Text(text)
                .font(AppTheme.Fonts.body)
                .padding(.trailing, AppTheme.Padding.standard)
            Spacer()
        }
        .padding(.vertical, AppTheme.Padding.bottomSmall)
    }
}



struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(locations: Locations())
    }
}
