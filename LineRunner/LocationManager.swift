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
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        
        print("func locationManager Plats uppdaterad! \(location ?? defaultCoordinate)")
       
        if let toDbLatitude = location?.latitude {
            print("location?.latitude = \(toDbLatitude)")
            if let toDbLongitude = location?.longitude {
                print("location?.longitude = \(toDbLongitude)")
                let toDbPosition = Position(id: "", positionLatitude: toDbLatitude, positionLongitude: toDbLongitude)
                print("toDbCoordinate = \(toDbPosition)")
                sendPositionToFirestore(position: toDbPosition)
            }
        }
        lineCoordinates.append(listenForCoordinateFromFirestore())
        print("lineCoordinates.append(listenForCoordinateFromFirestore())!!")
    }

    func sendPositionToFirestore(position: Position) {
        print("func sendCoordinateToFirestore")
        let db = Firestore.firestore()
        let ref = db.collection("Coordinates")
        do {
           _ = try  ref.addDocument(from: position)
            print("try func sendPositionToFirestore \(position)")
        } catch {
            print("error")
        }
        print("func sendPostitionToFirestore")
     }
    
    func listenForCoordinateFromFirestore() -> CLLocationCoordinate2D {
        print("func listenForCoordinateFromFirestore")
        db.collection("Coordinates").addSnapshotListener {
            snapshot, err in
            guard let snapshot = snapshot else {return}
            if let err = err {
                print("Error getting document \(err)")
            } else {
                print("a")
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
                        print("Here there should be a toLmCoordinate")
                        print("fromDB toLmCoordinate:  \(self.toLmCoordinate ?? self.defaultCoordinate)")
                        self.lineCoordinates.append(self.toLmCoordinate ?? self.defaultCoordinate)
                        print("lineCoordinates are \(self.lineCoordinates)")
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                    print("1")
                }
                print("2")
            }
            print("3")
        }
        print("4")
        if toLmCoordinate == nil {print("toLmCoordinate is nil")} else {
            print("toLmCoordinate is not nil")
            print("toLmCoordinate \(toLmCoordinate)")}
        return toLmCoordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
}

