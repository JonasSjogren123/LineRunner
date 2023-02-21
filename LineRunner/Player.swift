//
//  Player.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-16.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI
import MapKit

class Player : Codable, Identifiable {
    @DocumentID var id : String?
    var name : String = ""
    var score = 0
}
