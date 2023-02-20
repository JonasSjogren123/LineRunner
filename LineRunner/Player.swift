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

struct Player : Codable, Identifiable {
    @DocumentID var id : String?
    var name : String
    var category : String = ""
    var done: Bool = false
}
