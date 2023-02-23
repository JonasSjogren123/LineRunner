//
//  Coordinate.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-23.
//

import Foundation
import FirebaseFirestoreSwift

struct Coordinate  : Codable, Identifiable  {
    @DocumentID var id : String?
    var lat: Double
    var long: Double

}
