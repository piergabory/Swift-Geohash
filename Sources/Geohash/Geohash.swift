
public struct Geohash {
    
    public let string: String
    public let region: Region
    
    public var precision: Int { string.count }

    private static let alphabet: [Character] = Array("0123456789bcdefghjkmnpqrstuvwxyz")
    private static let subRegionBitMasks = (0...4).reversed().map { 1 << $0 }
    
    public static func region(forHash string: String) throws -> Region {
        let bits = try Geohash.binaryRepresentation(of: string)
        var region = Region.root
        for index in bits.indices {
            region = region.halfed(longitudinally: index % 2 == 0, keepNorthWestHemisphere: bits[index])
        }
        return region
    }
    
    public static func regionContaining(latitude: Double, longitude: Double, precision: Int = 12) -> Geohash {
        var hash = Geohash(string: "", region: .root)
        while hash.precision < precision {
            hash = hash.refine(towards: latitude, longitude)
        }
        return hash
    }
    
    public static func regionContaining(subregion: Region) -> Geohash {
        var hash = Geohash(string: "", region: .root)
        var previous = hash
        while hash.region.contains(subregion) {
            previous = hash
            hash = hash.refine(towards: subregion.latitudeMidPoint, subregion.longitudeMidPoint)
        }
        return previous
    }
    
    private func refine(towards latitude: Double, _ longitude: Double) -> Geohash {
        var alphabetIndex = 0
        var sliceLongitudinally = string.count % 2 == 0
        var subregion = region
        
        for bitMask in Geohash.subRegionBitMasks {
            let keepNorthWestHemisphere: Bool
            
            if sliceLongitudinally {
                keepNorthWestHemisphere = longitude > subregion.longitudeMidPoint
            } else {
                keepNorthWestHemisphere = latitude > subregion.latitudeMidPoint
            }

            subregion = subregion.halfed(longitudinally: sliceLongitudinally, keepNorthWestHemisphere: keepNorthWestHemisphere)
            sliceLongitudinally.toggle()
            
            if keepNorthWestHemisphere { alphabetIndex |= bitMask }
        }
        
        return Geohash(string: string + [Geohash.alphabet[alphabetIndex]], region: subregion)
    }
    
    private static func binaryRepresentation(of geohashString: String) throws -> [Bool] {
        var bits: [Bool] = []
        for symbol in geohashString {
            guard let decimalValue = Geohash.alphabet.firstIndex(of: symbol) else {
                throw InvalidSymbolError(symbol: symbol)
            }
            bits += subRegionBitMasks.reduce(into: []) { bits, mask in
                bits.append(decimalValue & mask != 0)
            }
        }
        return bits
    }
}

