//
//  File.swift
//  
//
//  Created by Pierre Gabory on 19/12/2020.
//

import CoreLocation

extension Geohash {
    public static func regionContaining(coordinate: CLLocationCoordinate2D, precision: Int = 12) -> Geohash {
        regionContaining(latitude: coordinate.latitude, longitude: coordinate.longitude, precision: precision)
    }
}

extension Geohash.Region {
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitudeMidPoint, longitude: longitudeMidPoint)
    }
}
