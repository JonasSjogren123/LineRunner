//
//  ContentView.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-14.

import SwiftUI
import MapKit
import Firebase
import FirebaseAuth

struct GameView: View {
    let db = Firestore.firestore()
    
    @StateObject var locationManager = LocationManager()
    //@StateObject var playerManager = PlayerManager()

    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.03125), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))

    @State var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    @State var coordinates: [CLLocationCoordinate2D] = []
    @State var shouldHide = false
    
    var body: some View {
        ZStack {
            MapView(
                region: region,
                lineCoordinates: locationManager.lineCoordinates
            )
            .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                locationManager.startLocationUpdates()
                self.shouldHide = true
            }) {
                Image(systemName: "pencil.and.outline")
                    .foregroundColor(.blue)
                    .font(.system(size: 100))
            }
            .opacity(shouldHide ? 0: 1)
        }
    }
    
   /* func listenForCoordinateFromFirestore(/*coordinates: [CLLocationCoordinate2D]*/) -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D]  = [] /*coordinates*/
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
                    case .success(let dBCoordinate)  :
                        //let latitude = coordinate.lat
                        //let longitude = coordinate.long
                        let coordinate = CLLocationCoordinate2D(latitude: dBCoordinate.lat, longitude: dBCoordinate.long)
                        print("fromDB:  \(coordinate)")
                        coordinates.append(coordinate)
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
        print("coordinates \(coordinates)")
        return coordinates
    }*/
}

