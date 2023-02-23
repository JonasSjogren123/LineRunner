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
        
        print("Plats uppdaterad! \(location)")
       
        if let latitude = location?.latitude as? Double {
            if let longitude = location?.longitude as? Double {
                    let coordinate = Coordinate(id: "", lat: latitude, long: longitude)
                    sendCoordinateToFirestore(coordinate: coordinate)
            }
        }
    }
    
    func sendCoordinateToFirestore(coordinate: Coordinate) {
        let db = Firestore.firestore()
        let ref = db.collection("Coordinates")
  
        do {
           _ = try  ref.addDocument(from: coordinate)
        } catch {
            print("error")
        }
     }
}

