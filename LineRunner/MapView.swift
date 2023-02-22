//
//  MapView.swift
//  MKPolylineTest20230205
//
//  Created by Jonas Sjögren on 2023-02-05.
//

import SwiftUI
import MapKit
import Foundation
import CoreLocation
import Firebase

struct MapView: UIViewRepresentable {
    
    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]

  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    mapView.region = region

    let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
    mapView.addOverlay(polyline)

    return mapView
  }

  func updateUIView(_ view: MKMapView, context: Context) {
    //lineCoordinates = places
    print("updateUIView")
    let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
    view.addOverlay(polyline)

  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

}

class Coordinator: NSObject, MKMapViewDelegate {
    
    let db = Firestore.firestore()
    var parent: MapView
    @State var coordinates = [Coordinates]()
    
    init(_ parent: MapView) {
    self.parent = parent
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let routePolyline = overlay as? MKPolyline {
      let renderer = MKPolylineRenderer(polyline: routePolyline)
      renderer.strokeColor = UIColor.systemBlue
      renderer.lineWidth = 4
      return renderer
    }
    return MKOverlayRenderer()
  }
    
    func listenToFirestore() {
        
        guard let user = Auth.auth().currentUser else {return}

        db.collection("items").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                self.coordinates.removeAll()
                for document in snapshot.documents {

                    let result = Result {
                        try document.data(as: Coordinates.self)
                    }
                    switch result  {
                    case .success(let coordinate)  :
                        coordinates.append(coordinate)
                        print("testFirebaseItems FFFFFFFFFFFF\(self.coordinates)FFFFFFFFFFFF")
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }
}

