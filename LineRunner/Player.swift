//
//  Player.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-16.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

class Player : Identifiable, ObservableObject {
    @StateObject var locationManager = LocationManager()
    //var coordinates = locationManager.lineCoordinates
    //@DocumentID var id : String?
    let id = UUID()
    var name : String
    var score: Int = 0
    var coordinates: [Double] = []
    
    init(name: String) {
        self.name = name
    }
    
}

