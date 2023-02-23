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

    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.03125), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))

    @State var player = Player()
    @State var players = [Player]()
    @State var shouldHide = false
    
    var body: some View {
        ZStack {
            MapView(
                region: region
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
}

