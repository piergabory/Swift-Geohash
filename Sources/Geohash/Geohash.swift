
public struct Geohash {
    
    public let string: String
    public let region: Region
    
    public var precision: Int { string.count }

    private static let alphabet: [Character] = Array("0123456789bcdefghjkmnpqrstuvwxyz")
    private static let subRegionBitMasks = (0...4).reversed().map { 1 << $0 }
    
    public static func decode(string: String) throws -> Region {
        let bits = try Geohash.binaryRepresentation(of: string)
        var region = Region.root
        for index in bits.indices {
            region = region.halfed(longitudinally: index % 2 == 0, keepNorthWestHemisphere: bits[index])
        }
        return region
    }
    
    public static func encode(latitude: Double, longitude: Double, precision: Int = 12) -> Geohash {
        var hash = Geohash(string: "", region: .root)
        while hash.precision < precision {
           hash = refine(geohash: hash, towards: latitude, longitude)
        }
        return hash
    }
    
    public static func findRegionContaining(subregion: Region) -> Geohash {
        var hash = Geohash(string: "", region: .root)
        var previous = hash
        while hash.region.contains(subregion) {
            previous = hash
            hash = refine(geohash: hash, towards: subregion.latitudeMidPoint, subregion.longitudeMidPoint)
        }
        return previous
    }
    
    private static func refine(geohash: Geohash, towards latitude: Double, _ longitude: Double) -> Geohash {
        var alphabetIndex = 0
        var sliceLongitudinally = geohash.string.count % 2 == 0
        var subregion = geohash.region
        
        for bitMask in subRegionBitMasks {
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
        
        return Geohash(string: geohash.string + [alphabet[alphabetIndex]], region: subregion)
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

