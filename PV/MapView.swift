//
//  MapView.swift
//  PV
//
//  Created by Jakob Stinnes on 19.10.23.
//


import Foundation
import MapKit
import SwiftUI

struct LookAroundView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = .satelliteFlyover // Use satellite flyover for 3D satellite imagery
        mapView.isPitchEnabled = true // Enable pitch for 3D viewing
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 1, pitch: 45, heading: 0) // Adjusted pitch for oblique view
        mapView.setCamera(camera, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: LookAroundView
        
        init(_ parent: LookAroundView) {
            self.parent = parent
        }
    }
}


struct MapView: View {
    @EnvironmentObject var locations: Locations
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.5511, longitude: 9.9937), // Centered on Hamburg, Germany
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    let pinnedCoordinate = CLLocationCoordinate2D(latitude: 53.5500, longitude: 9.9937)
    @State private var showLookAround = false

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
                
                Button("Show Look Around") {
                    showLookAround.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                if showLookAround {
                    LookAroundView(coordinate: CLLocationCoordinate2D(latitude: 53.56758, longitude: 9.850858))
                        .frame(height: 300)
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


