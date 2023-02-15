//
//  ContentView.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-14.

// 1. locationmanager ska vara ett stateobject
// 2. skicka med din locationmanager i stället för Places in mapview
// -  Läs på hur du skickar en stateobject till en anna view
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    /*@State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.0312186), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))*/
    
    @State var region = MKCoordinateRegion(center: (locationManager.centerCoordinate ?? CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.0312186)), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    var body: some View {
        VStack {
            MapView(
                region: region,
                lineCoordinates: locationManager.lineCoordinates
            )
            .edgesIgnoringSafeArea(.all)
        }
       /* Button(action: {
            addPlaceTest()
            print("Button addPlace pressed")
        }) {
            Text("Add place")
        }*/
        Button(action: {
                locationManager.startLocationUpdates()
        }) {
            Text("Start updates")
        }
    }
}

