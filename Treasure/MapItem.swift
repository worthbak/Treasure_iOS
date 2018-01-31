//
//  MapItem.swift
//  Treasure
//
//  Created by Worth Baker on 1/31/18.
//  Copyright © 2018 HouseCanary. All rights reserved.
//

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
