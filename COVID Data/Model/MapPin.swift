//
//  MapPin.swift
//  COVID Data
//
//  Created by David Kababyan on 11/04/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import Foundation
import MapKit


class MapPin : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
