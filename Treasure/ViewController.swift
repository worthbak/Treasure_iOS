//
//  ViewController.swift
//  Treasure
//
//  Created by Worth Baker on 1/27/18.
//  Copyright © 2018 HouseCanary. All rights reserved.
//

import UIKit
import MapKit

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
                existing.clusteringIdentifier = "mapItemClustered" // remove to prevent clustering
                return existing
            } else {
                let new = MKAnnotationView(annotation: annotation, reuseIdentifier: "mapItem")
                new.image = item.itemType.image
                new.clusteringIdentifier = "mapItemClustered" // remove to prevent clustering
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
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else if let polyline = overlay as? MKPolyline {
            let rend = MKPolylineRenderer(polyline: polyline)
            rend.strokeColor = .blue
            rend.lineWidth = 4.0
            
            return rend
        } else {
            return MKOverlayRenderer()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.isSelected = false
        
        guard let annotation = view.annotation as? MapItem else { return }
        let placemark = MKPlacemark(coordinate: annotation.coordinate)
        let item = MKMapItem(placemark: placemark)
        tappedPoints.append(item)
        
        if tappedPoints.count >= 2 {
            let source = tappedPoints[tappedPoints.count - 2]
            let destination = tappedPoints[tappedPoints.count - 1]
            
            let directionReq = MKDirectionsRequest()
            directionReq.source = source
            directionReq.destination = destination
            directionReq.transportType = .walking
            MKDirections(request: directionReq).calculate(completionHandler: { (res, err) in
                if let response = res, let route = response.routes.first {
                    mapView.add(route.polyline, level: .aboveLabels)
                }
            })
        }
    }
}

