//
//  CustomOverlay.swift
//  Treasure
//
//  Created by Worth Baker on 1/30/18.
//  Copyright © 2018 HouseCanary. All rights reserved.
//

import MapKit

final class CustomOverlay: MKTileOverlay {
    
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        let url = URL(string: "http://c.tile.stamen.com/watercolor/\(path.z)/\(path.x)/\(path.y).jpg")!
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            result(data, err)
            }.resume()
    }
}
