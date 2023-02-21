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
    @StateObject var playerManager = PlayerManager()

    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.0312186), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))

    @State var player = Player()
    @State var players = [Player]()
    
    var body: some View {
        VStack {
            MapView(
                region: region,
                lineCoordinates: locationManager.lineCoordinates
            )
            .edgesIgnoringSafeArea(.all)
        }
        Button(action: {
                locationManager.startLocationUpdates()
        }) {
            Text("PLAY")
        }
    }
    

    /*func saveToFirestore(itemName: String) {
        let item = player(itemName: "Test")
       //let item = TestFirebaseItem(name: itemName)

    
        do {
            _ = try db.collection("items").addDocument(data: item)
        } catch {
            print("Error saving to DB")
        }
    }
     */
   /*  func listenToFirestore() {
        db.collection("items").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                players.removeAll()
                for document in snapshot.documents {

                    let result = Result {
                        try document.data(as: TestFirebaseItem.self)
                    }
                    switch result  {
                    case .success(let item)  :
                        players.append(item)
                        print("testFirebaseItems FFFFFFFFFFFF\(players)FFFFFFFFFFFF")
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }
    */
}

