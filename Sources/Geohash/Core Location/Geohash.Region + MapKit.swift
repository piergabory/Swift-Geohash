//
//  File.swift
//  
//
//  Created by Pierre Gabory on 19/12/2020.
//

import MapKit

extension Geohash.Region {
    
    public var coordinateSpan: MKCoordinateSpan {
        MKCoordinateSpan(latitudeDelta: northLatitude - southLatitude, longitudeDelta: westLongitude - eastLongitude)
    }
    
    public var region: MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: coordinateSpan)
    }
    
    public init(region: MKCoordinateRegion) {
        self.init(northLatitude: region.center.latitude + region.span.latitudeDelta,
                  southLatitude: region.center.latitude - region.span.latitudeDelta,
                  westLongitude: region.center.longitude + region.span.longitudeDelta,
                  eastLongitude: region.center.longitude - region.span.longitudeDelta)
    }
}
