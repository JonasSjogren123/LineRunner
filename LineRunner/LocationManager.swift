//
//  LocationManager.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-14.
//
import SwiftUI
import Foundation
import CoreLocation
import Firebase

class LocationManager : NSObject, CLLocationManagerDelegate , ObservableObject{
  
    let manager = CLLocationManager()
    var location : CLLocationCoordinate2D?

    @Published var coordinates = Coordinates()
    //@Published var locations: [CLLocationCoordinate2D] = []
    @Published var lineCoordinates: [CLLocationCoordinate2D] = []
    @State var latitude: Double = 0
    @State var longitude: Double = 0
    @State var coordinate: [Double] = [0.0, 0.0]

    override init() {
        super.init()
        manager.delegate = self
    }
    
    func startLocationUpdates() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //var location: CLLocationCoordinate2D
        location = locations.first?.coordinate
        latitude = location?.latitude ?? 0
        longitude = location?.longitude ?? 0
        coordinate = [latitude, longitude]
        
        print("LLLLLLLLLLLLL latitude = \(latitude), longitude = \(longitude) LLLLLLLLLLLL")

        print("Plats uppdaterad! \(location)")
       
        lineCoordinates.append(location!)
        sendCoordinateToFirestore(coordinate: coordinate)

       print("lineCoordinates \(lineCoordinates)")
    }
    
     func sendCoordinateToFirestore(coordinate: [Double]) {
        let db = Firestore.firestore()
        let ref = db.collection("Coordinates").document("coordinate")
        ref.setData(["latitude": latitude, "longitude": longitude]) { error in
            if let error = error {
                print(error.localizedDescription)
                print("Det blev fel med uppladdningen till Firestore!")
            }
        }
        print("Det blev nästan rätt med uppladdningen till Firestore!")

        print("func sendCoordinateToFirestore")
     }
}

