//
//  File.swift
//  
//
//  Created by Pierre Gabory on 19/12/2020.
//

import Foundation

extension Geohash {
    
    public struct Region {
        public let northLatitude: Double
        public let southLatitude: Double
        public let westLongitude: Double
        public let eastLongitude: Double
        
        public var latitudeMidPoint: Double { (northLatitude + southLatitude) / 2 }
        public var longitudeMidPoint: Double { (westLongitude + eastLongitude) / 2 }
        
        public init(northLatitude: Double,
             southLatitude: Double,
             westLongitude: Double,
             eastLongitude: Double) {
            self.northLatitude = northLatitude
            self.southLatitude = southLatitude
            self.westLongitude = westLongitude
            self.eastLongitude = eastLongitude
        }
        
        static let root = Region(
            northLatitude: 90, southLatitude: -90,
            westLongitude: 180, eastLongitude: -180
        )
        
        func halfed(longitudinally: Bool, keepNorthWestHemisphere: Bool) -> Self {
            Region(
                northLatitude: !longitudinally && !keepNorthWestHemisphere ? latitudeMidPoint : northLatitude,
                southLatitude: !longitudinally && keepNorthWestHemisphere ? latitudeMidPoint : southLatitude,
                westLongitude: longitudinally && !keepNorthWestHemisphere ? longitudeMidPoint : westLongitude,
                eastLongitude: longitudinally && keepNorthWestHemisphere ? longitudeMidPoint : eastLongitude
            )
        }
        
        func contains(_ subRegion: Region) -> Bool {
            let latitudeCheck = northLatitude > subRegion.northLatitude && southLatitude < subRegion.southLatitude
            let longitudeCheck = westLongitude > subRegion.westLongitude && eastLongitude < subRegion.eastLongitude
            return latitudeCheck && longitudeCheck
        }
    }
    
}
