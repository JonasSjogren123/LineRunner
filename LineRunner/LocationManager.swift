//
//  LocationManager.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-14.
//
import SwiftUI
import Foundation
import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate , ObservableObject{
    let manager = CLLocationManager()
    var location : CLLocationCoordinate2D?

    @Published var coordinates = Coordinates()
    //@Published var locations: [CLLocationCoordinate2D] = []
    @Published var lineCoordinates: [CLLocationCoordinate2D] = []
    
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
        print("Plats uppdaterad! \(location)")
       
        lineCoordinates.append(location!)
       print("lineCoordinates \(lineCoordinates)")
    }
    
    func convertCllocationCoordinate2DToGepoint() {
        
    }
    
    /*func saveToFirestore(itemName: String) {
        let item = player(itemName: "Test")
       //let item = TestFirebaseItem(name: itemName)

    
        do {
            _ = try db.collection("items").addDocument(data: item)
        } catch {
            print("Error saving to DB")
        }
    }*/
    
    
}

