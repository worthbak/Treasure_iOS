//
//  ViewController.swift
//  Treasure
//
//  Created by Worth Baker on 1/27/18.
//  Copyright © 2018 HouseCanary. All rights reserved.
//

import UIKit
import MapKit

class CustomOverlay: MKTileOverlay {

    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        let url = URL(string: "http://c.tile.stamen.com/watercolor/\(path.z)/\(path.x)/\(path.y).jpg")!
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            path.prettyPrint()
            result(data, err)
        }.resume()
    }
}

final class ViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let overlay = CustomOverlay()
        overlay.canReplaceMapContent = true
        mapView.add(overlay, level: .aboveLabels)
        
        let coordinate = CLLocationCoordinate2D(latitude: 40.0166, longitude: -105.2817)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer()
        }
        
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
}
