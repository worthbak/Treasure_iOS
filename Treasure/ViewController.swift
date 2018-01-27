//
//  ViewController.swift
//  Treasure
//
//  Created by Worth Baker on 1/27/18.
//  Copyright © 2018 HouseCanary. All rights reserved.
//

import UIKit
import MapKit

final class MapData: NSObject, MKAnnotation {
    static let resuseId = "MapData"
    
    // minimum MKAnnotation conformance
    let coordinate: CLLocationCoordinate2D
    
    init(_ coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

class ViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
}

extension ViewController: MKMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coordinate = CLLocationCoordinate2D(latitude: 40.0166, longitude: -105.2817)
        let annotation = MapData(coordinate)
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let existing = mapView.dequeueReusableAnnotationView(withIdentifier: MapData.resuseId) {
            existing.annotation = annotation
            return existing
        } else {
            return MKPinAnnotationView(annotation: annotation, reuseIdentifier: MapData.resuseId)
        }
    }
}
