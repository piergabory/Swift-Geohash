//
//  File.swift
//  
//
//  Created by Pierre Gabory on 19/12/2020.
//

import Foundation

extension Geohash {
    
    public struct Region {
        let northLatitude: Double
        let southLatitude: Double
        let westLongitude: Double
        let eastLongitude: Double
        
        static let root = Region(
            northLatitude: 90, southLatitude: -90,
            westLongitude: 180, eastLongitude: -180
        )
        
        var latitudeMidPoint: Double { (northLatitude + southLatitude) / 2 }
        var longitudeMidPoint: Double { (westLongitude + eastLongitude) / 2 }
        
        func halfed(longitudinally: Bool, keepNorthWestHemisphere: Bool) -> Self {
            Region(
                northLatitude: !longitudinally && !keepNorthWestHemisphere ? latitudeMidPoint : northLatitude,
                southLatitude: !longitudinally && keepNorthWestHemisphere ? latitudeMidPoint : southLatitude,
                westLongitude: longitudinally && !keepNorthWestHemisphere ? longitudeMidPoint : westLongitude,
                eastLongitude: longitudinally && keepNorthWestHemisphere ? longitudeMidPoint : eastLongitude
            )
        }
    }
    
}
