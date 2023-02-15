//
//  LocationManager.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-14.
//
import SwiftUI
import Foundation
import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate , ObservableObject {
    let manager = CLLocationManager()
    @Published var location : CLLocationCoordinate2D?

    //@Published var lineCoordinates: [CLLocationCoordinate2D] = []
    @Published var coordinates = Coordinates()
    @Published var locations: [CLLocationCoordinate2D] = []
    @Published var lineCoordinates: [CLLocationCoordinate2D] = []
    @Published var minMaxCoordinates: [CLLocationCoordinate2D?] = []
    @Published var centerCoordinate = CLLocationCoordinate2D?(latitude: 37.3323341, longitude: -122.0312186)



    override init() {
        super.init()
        manager.delegate = self
        self.minMaxCoordinates = calculateMinMaxCoordinates(lineCoordinates)
        self.centerCoordinate = calculateCenterCoordinate(lineCoordinates)
    }
    
    func startLocationUpdates() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //var location: CLLocationCoordinate2D
        location = locations.first?.coordinate
        //print("Plats uppdaterad! \(location)")
       
        lineCoordinates.append(location!)
       //print("lineCoordinates \(lineCoordinates)")
        calculateMinMaxCoordinates(lineCoordinates)
        calculateCenterCoordinate(lineCoordinates)
        print("!!!!!!!!calculateMinMaxCoordinate MMMMMMMM\(calculateMinMaxCoordinates(lineCoordinates))MMMMMMMM")
        print("!!!!!!!!calculateCenterCoordinate CCCCCCCC\(calculateCenterCoordinate(lineCoordinates))CCCCCCCC")
    }
    
    func calculateMinMaxCoordinates (_: [CLLocationCoordinate2D])  -> [CLLocationCoordinate2D?] {
        
        let minLatitude = CLLocationDegrees(lineCoordinates.min {$0.latitude < $1.latitude}?.latitude ?? 0)
        let minLongitude = CLLocationDegrees(lineCoordinates.min {$0.longitude < $1.longitude}?.longitude ?? 0)
        let maxLatitude = CLLocationDegrees(lineCoordinates.min {$0.latitude > $1.latitude}?.latitude ?? 0)
        let maxLongitude = CLLocationDegrees(lineCoordinates.max{$0.longitude > $1.longitude}?.longitude ?? 0)

        let minCoordinate = CLLocationCoordinate2D(latitude: minLatitude, longitude: minLongitude)
        let maxCoordinate = CLLocationCoordinate2D(latitude: maxLatitude, longitude: maxLongitude)

        let minMaxCoordinate: [CLLocationCoordinate2D?] = [minCoordinate, maxCoordinate]
       
        return minMaxCoordinate
    }
    
    func calculateCenterCoordinate (_: [CLLocationCoordinate2D])  -> CLLocationCoordinate2D? {
        
        let minLatitude = CLLocationDegrees(lineCoordinates.min {$0.latitude < $1.latitude}?.latitude ?? 0)
        let minLongitude = CLLocationDegrees(lineCoordinates.min {$0.longitude < $1.longitude}?.longitude ?? 0)
        let maxLatitude = CLLocationDegrees(lineCoordinates.min {$0.latitude > $1.latitude}?.latitude ?? 0)
        let maxLongitude = CLLocationDegrees(lineCoordinates.max{$0.longitude > $1.longitude}?.longitude ?? 0)
        
        let minCoordinate = CLLocationCoordinate2D(latitude: minLatitude, longitude: minLongitude)
        let maxCoordinate = CLLocationCoordinate2D(latitude: maxLatitude, longitude: maxLongitude)
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: (minCoordinate.latitude + maxCoordinate.latitude)/2, longitude: (minCoordinate.longitude + maxCoordinate.longitude)/2)
        
        return centerCoordinate
    }
}

