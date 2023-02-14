//
//  Coordinates.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-14.
//

import Foundation
import MapKit
import SwiftUI


class Coordinates: ObservableObject {
    
    @Published var lineCoordinates: [CLLocationCoordinate2D] = []
    
}
