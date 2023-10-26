//
//  MapView.swift
//  PV
//
//  Created by Jakob Stinnes on 19.10.23.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: View {
    @EnvironmentObject var locations: Locations
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.5511, longitude: 9.9937), // Centered on Hamburg, Germany
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    let pinnedCoordinate = CLLocationCoordinate2D(latitude: 53.5500, longitude: 9.9937)

    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.Padding.standard) {
                // Top bar with Logo and Title
                ZStack {
                    Text("Map")
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
                
                // Map
                Map(coordinateRegion: $region, annotationItems: Array(locations.places.prefix(10))) { location in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                        NavigationLink(destination: ContactDetailsView(location: location)) {
                            Image(AppTheme.Icons.logo)
                                .resizable()
                                .cornerRadius(10)
                                .frame(width: 40, height: 40)
                                .shadow(radius: 3)
                        }
                    }
                }
                Spacer()
            }
            .background(AppTheme.Colors.background(for: colorScheme))
            .padding(.top, 10)
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
        }
    }

    @Environment(\.colorScheme) private var colorScheme
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let locations = Locations()
        return MapView()
            .environmentObject(locations)
    }
}



