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
//
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
       
        if let latitude = location?.latitude {
            if let longitude = location?.longitude {
                    let toDbCoordinate = Coordinate(id: "", lat: latitude, long: longitude)
                    sendCoordinateToFirestore(coordinate: toDbCoordinate)
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
    
    func listenForCoordinateFromFirestore(/*coordinates: [CLLocationCoordinate2D]*/) -> [CLLocationCoordinate2D] {
        var toLmCoordinates: [CLLocationCoordinate2D]  = [] /*coordinates*/
        let db = Firestore.firestore()
        
        db.collection("Coordinates").addSnapshotListener {
            snapshot, err in
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                //coordinates.removeAll()
                for document in snapshot.documents {
                    let result = Result {
                        try document.data(as: Coordinate.self)
                    }
                    switch result  {
                    case .success(let fromDbCoordinate)  :
                        //let latitude = coordinate.lat
                        //let longitude = coordinate.long
                        let toLmCordinate = CLLocationCoordinate2D(latitude: fromDbCoordinate.lat, longitude: fromDbCoordinate.long)
                        print("fromDB:  \(toLmCordinate)")
                        toLmCoordinates.append(toLmCordinate)
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
        print("coordinates \(toLmCoordinates)")
        return toLmCoordinates
    }
}

