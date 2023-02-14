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
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.0312186), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
    @State var places = [
        CLLocationCoordinate2D(latitude: 37.3340000, longitude: -122.034),
        CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.029),
        CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.024)
    ]
    
    var body: some View {
        VStack {
            MapView(
                region: region,
                lineCoordinates: places
            )
            .edgesIgnoringSafeArea(.all)
        }
        Button(action: {
            addPlaceTest()
            print("Button addPlace pressed")
        }) {
            Text("Add place")
        }
        Button(action: {
                locationManager.startLocationUpdates()
        }) {
            Text("Start updates")
        }
    }
    
    func addPlaceTest() {
        let newPlace = CLLocationCoordinate2D(latitude: 37.33550, longitude: -122.012363)
        places.append(newPlace)
        print("Button addPin pressed, function addPin Excecuted, newPlace appended")
        print(places)
        }
    
    func addPlace() {
        print("function addPlace activated")
            if let location = locationManager.location {
                let newPlace = CLLocationCoordinate2D(
                                     latitude: location.latitude,
                                     longitude: location.longitude)
                places.append(newPlace)
                print(places)
            }
        }
}

