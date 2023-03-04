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
    let db = Firestore.firestore()
    let manager = CLLocationManager()
    var location : CLLocationCoordinate2D?
    
    @Published var lastCoordinate: CLLocationCoordinate2D?
    @Published var positions = Positions()
    @Published var toLmCoordinate: CLLocationCoordinate2D?
    @Published var toLmCoordinates: [CLLocationCoordinate2D]?
    @Published var lineCoordinates: [CLLocationCoordinate2D] = []
    let defaultCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func startLocationUpdates() {
        manager.requestWhenInUseAuthorization()
        manager.distanceFilter = 25
        deleteAllCoordinatesFromFirestore()
        manager.startUpdatingLocation()
        listenForCoordinateFromFirestore()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        
        print("func locationManager Plats uppdaterad! \(location ?? defaultCoordinate)")
        
        if let toDbLatitude = location?.latitude {
            if let toDbLongitude = location?.longitude {
                let toDbPosition = Position(id: "", positionLatitude: toDbLatitude, positionLongitude: toDbLongitude, timeStamp: Date().timeIntervalSince1970)
                sendPositionToFirestore(position: toDbPosition)
            }
        }
    }
    
    func sendPositionToFirestore(position: Position) {
        print("func sendCoordinateToFirestore")
        let db = Firestore.firestore()
        let ref = db.collection("Coordinates")
        // Delete every document in ref
        do {
            _ = try  ref.addDocument(from: position)
            print("try func sendPositionToFirestore \(position)")
        } catch {
            print("error")
        }
    }
    
    func deleteAllCoordinatesFromFirestore() {
        let db = Firestore.firestore()
        let ref = db.collection("Coordinates")
        let buffersize = 100
        for document in ref {}
        //1. Identifiera alla coordinater som skall tas bort ifrån ref
        
        //2. Gör en for loop som tar bort alla koordinaterna från ref
    }
    
    func listenForCoordinateFromFirestore() {
        print("func listenForCoordinateFromFirestore")
        
        db.collection("Coordinates").order(by: "timeStamp", descending: false).addSnapshotListener {
            snapshot, err in
            guard let snapshot = snapshot else {return}
            if let err = err {
                print("Error getting document \(err)")
            } else {
                self.lineCoordinates.removeAll()
                for document in snapshot.documents {
                    let result = Result {
                        try document.data(as: Position.self)
                    }
                    switch result  {
                    case .success(let fromDbCoordinate)  :
                        let latitude = fromDbCoordinate.positionLatitude
                        let longitude = fromDbCoordinate.positionLongitude
                        self.toLmCoordinate = CLLocationCoordinate2D(latitude: latitude , longitude: longitude )
                        self.lineCoordinates.append(self.toLmCoordinate ?? self.defaultCoordinate)
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }
}
