//
//  WorldView.swift
//  PV
//
//  Created by Jakob Stinnes on 19.10.23.
//

import Foundation
import MapKit
import SwiftUI

struct WorldView: View {
    @EnvironmentObject var locations: Locations
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.5511, longitude: 9.9937), // Centered on Hamburg, Germany
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    let pinnedCoordinate = CLLocationCoordinate2D(latitude: 53.5500, longitude: 9.9937)

    private let mainColor: Color = .green

    var body: some View {
        VStack(spacing: 30) {
            // Top bar with Logo and Title
            ZStack {
                Text("Map")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.primary)  // center on the screen
                
                HStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Spacer()
                }
                .padding(.horizontal, 30)
            }
            .padding(.top, 60)
            
            // Map
            //Map(coordinateRegion: $region, annotationItems: locations.places) { location in
            Map(coordinateRegion: $region, annotationItems: Array(locations.places.prefix(10))
                ) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                    NavigationLink(destination: ContactDetailsView(location: location)) {  // Navigate to the contact's details
                        Image("logo")
                            .resizable()
                            .cornerRadius(10)
                            .frame(width: 40, height: 40)  // Adjust the frame dimensions as needed
                            .shadow(radius: 3)
                    }
                }
            }
            Spacer() // Pushes the Map to take the remaining space
        }
        .padding(.top, 10)
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }
}


struct WorldView_Previews: PreviewProvider {
    static var previews: some View {
        let locations = Locations()
        return WorldView()
            .environmentObject(locations)
    }
}



