//
//  Coordinate.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-23.
//

import Foundation
import FirebaseFirestoreSwift
import MapKit

struct Position  : Codable, Identifiable  {
    @DocumentID var id : String?
    var positionLatitude: Double
    var positionLongitude: Double
    
    var coordinate : CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: positionLatitude, longitude: positionLongitude)
        }

}
