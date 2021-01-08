//
//  File.swift
//  
//
//  Created by Pierre Gabory on 08/01/2021.
//

import Foundation

extension Geohash: Hashable {
    public static func == (lhs: Geohash, rhs: Geohash) -> Bool {
        lhs.string == rhs.string
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(string.hash)
    }
}
