//
//  ContentView.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-14.

import SwiftUI
import MapKit
import Firebase
import FirebaseAuth

struct ContentView: View {
    
    let db = Firestore.firestore()
    
    @StateObject var locationManager = LocationManager()
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.0312186), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
    @State var places = [
        CLLocationCoordinate2D(latitude: 37.3340000, longitude: -122.034),
        CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.029),
        CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.024)
    ]
    
    @State var testFirebaseItems = [TestFirebaseItem]()
    
    var body: some View {
        VStack {
            MapView(
                region: region,
                lineCoordinates: locationManager.lineCoordinates
            )
            .edgesIgnoringSafeArea(.all)
        }
        Button(action: {
            saveToFirestore(itemName: "Skall bli en massa koordinater")
            print("Button saveToFirestore pressed")
        }) {
            Text("Save To Firestore")
        }
        Button(action: {
            listenToFirestore()
            print("Button listeToFirestore pressed")
        }) {
            Text("Listen to Firestore")
        }
        Button(action: {
            addPlaceTest()
            print("Button addPlace pressed")
        }) {
            Text("Add place")
        }
        Button(action: {
                locationManager.startLocationUpdates()
        }) {
            Text("PLAY")
        }
    }
    
    func addPlaceTest() {
        let newPlace = CLLocationCoordinate2D(latitude: 37.33550, longitude: -122.012363)
        places.append(newPlace)
        print("Button addPin pressed, function addPin Excecuted, newPlace appended")
        print(places)
        }
    

    func saveToFirestore(itemName: String) {
        let item = TestFirebaseItem(name: itemName)
    
        do {
            _ = try db.collection("items").addDocument(from: item)
        } catch {
            print("Error saving to DB")
        }
    }
    
    func listenToFirestore() {
        db.collection("items").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                testFirebaseItems.removeAll()
                for document in snapshot.documents {

                    let result = Result {
                        try document.data(as: TestFirebaseItem.self)
                    }
                    switch result  {
                    case .success(let item)  :
                        testFirebaseItems.append(item)
                        print("testFirebaseItems FFFFFFFFFFFF\(testFirebaseItems)FFFFFFFFFFFF")
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }
    
}

