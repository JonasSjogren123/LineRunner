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
    
   // @EnvironmentObject var coordinates: Coordinates
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
        location = locations.first?.coordinate
        print("Plats uppdaterad! \(location)")
       
        //coordinates.lineCoordinates.append(location!)
       // print("lineCoordinates \(coordinates.lineCoordinates)")
    }
}

