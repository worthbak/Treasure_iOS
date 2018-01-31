//
//  ViewController.swift
//  Treasure
//
//  Created by Worth Baker on 1/27/18.
//  Copyright © 2018 HouseCanary. All rights reserved.
//

import UIKit
import MapKit

final class MapItem: NSObject, MKAnnotation {
    enum ItemType {
        case treasure, noise
        
        var image: UIImage {
            switch self {
            case .treasure:
                return #imageLiteral(resourceName: "treasure")
            case .noise:
                return #imageLiteral(resourceName: "noise")
            }
        }
    }
    
    let itemType: ItemType
    let coordinate: CLLocationCoordinate2D
    
    init(_ type: ItemType, coordinate: CLLocationCoordinate2D) {
        itemType = type
        self.coordinate = coordinate
    }
}

final class ViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    private var tappedPoints = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let overlay = CustomOverlay()
        overlay.canReplaceMapContent = true
        mapView.add(overlay, level: .aboveLabels)
        
        let coordinate = CLLocationCoordinate2D(latitude: 40.0166, longitude: -105.2817)
        let annotation = MapItem(.treasure, coordinate: coordinate)
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)
        
        for randCoordinate in makeRandomCoordinates(in: region) {
            let annotation = MapItem(.noise, coordinate: randCoordinate)
            mapView.addAnnotation(annotation)
        }
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let item = annotation as? MapItem {
            if let existing = mapView.dequeueReusableAnnotationView(withIdentifier: "mapItem") {
                existing.annotation = item
                existing.image = item.itemType.image
                existing.clusteringIdentifier = "mapItemClustered"
                return existing
            } else {
                let new = MKAnnotationView(annotation: annotation, reuseIdentifier: "mapItem")
                new.image = item.itemType.image
                new.clusteringIdentifier = "mapItemClustered"
                return new
            }
        } else if let cluster = annotation as? MKClusterAnnotation {
            if let existing = mapView.dequeueReusableAnnotationView(withIdentifier: "clusterView") {
                existing.annotation = cluster
                existing.image = #imageLiteral(resourceName: "cluster")
                return existing
            } else {
                let new = MKAnnotationView(annotation: annotation, reuseIdentifier: "clusterView")
                new.image = #imageLiteral(resourceName: "cluster")
                return new
            }
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer()
        }
        
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
}

