//
//  ContentView.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-14.
//

import SwiftUI
import MapKit

// 1. locationmanager ska vara ett stateobject
// 2. skicka med din locationmanager i stället för Places in mapview
// -  Läs på hur du skickar en stateobject till en anna view

struct ContentView: View {
    var locationManager = LocationManager()
    @StateObject var coordinats = Coordinates()
    @State var timeRemaining = 10
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.0312186), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
    @State var places = [
        CLLocationCoordinate2D(latitude: 37.3340000, longitude: -122.034),
        CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.029),
        CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.024)
    ]
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     var   location = locations.first?.coordinate
    
        location?.latitude
        location?.longitude
        
        places.append(CLLocationCoordinate2D(latitude: location?.latitude ?? 0, longitude: location?.longitude ?? 0))
      
        
    }


        var body2: some View {
            Text("")
                .onReceive(timer) { input in
                
                    locationManager()
                    
                    
                }
        }
    
    
    
    
    
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
    
    func addCoordinate() {
        
        
        
        
        
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

