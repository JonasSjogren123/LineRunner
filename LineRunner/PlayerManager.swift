//
//  PlayerManager.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-16.
//
import SwiftUI
import Foundation
import CoreLocation
import FirebaseFirestoreSwift
import MapKit
import Firebase
import FirebaseAuth

class PlayerManager: ObservableObject {
    @Published var player = Player(name: "nameTest")
    let db = Firestore.firestore()
    
    @State var players = [Player]()

    func saveToFirestore(itemName: String) {
        let item = Player(name: itemName)
    
        do {
            _ = try db.collection("items").addDocument(from: item)
        } catch {
            print("Error saving to DB")
        }
    }
    
    func listenToFirestore() {
        db.collection("items").addSnapshotListener { [self] snapshot, err in
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                players.removeAll()
                for document in snapshot.documents {

                    let result = Result {
                        try document.data(as: Player.self)
                    }
                    switch result  {
                    case .success(let item)  :
                        self.$player.append(item)
                        print("testFirebaseItems FFFFFFFFFFFF\(self.player)FFFFFFFFFFFF")
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }
    
}

