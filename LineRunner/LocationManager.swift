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
  
    let db = Firestore.firestore()

    let manager = CLLocationManager()
    var location : CLLocationCoordinate2D?

    @Published var coordinates = Coordinates()
    //@Published var locations: [CLLocationCoordinate2D] = []
    @Published var lineCoordinates: [CLLocationCoordinate2D] = []
    @State var latitude: Double = 0
    @State var longitude: Double = 0
    @State var coordinate: [Double] = [0.0, 0.0]

    
    let player = Player()

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
        
        saveToFirestore(coordinate: coordinate)
        print("LLLLLLLLLLLLL latitude = \(latitude), longitude = \(longitude) LLLLLLLLLLLL")

        print("Plats uppdaterad! \(location)")
       
        lineCoordinates.append(location!)
       print("lineCoordinates \(lineCoordinates)")
    }
    
     func saveToFirestore(coordinate: [Double]) {
         let coordinate = [Double](coordinate)
         guard let user = Auth.auth().currentUser else {return}
         
         do {
             _ = try db.collection("users").document(user.uid).collection("items").addDocument(from: coordinate)
         } catch {
             print("Error saving to DB")
         }
     }
}

