
public struct Geohash {

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
    
    public static func encode(latitude: Double, longitude: Double, precision: Int = 12) -> String {
        var region = Region.root
        var bitMaskIndex = 0
        var alphabetIndex = 0
        var sliceLongitudinally = true
        var hash = ""
        
        while hash.count < precision {
            let keepNorthWestHemisphere: Bool
            if sliceLongitudinally {
                keepNorthWestHemisphere = longitude > region.longitudeMidPoint
            } else {
                keepNorthWestHemisphere = latitude > region.latitudeMidPoint
            }
            
            region = region.halfed(
                longitudinally: sliceLongitudinally,
                keepNorthWestHemisphere: keepNorthWestHemisphere
            )
            sliceLongitudinally.toggle()
            
            if keepNorthWestHemisphere {
                alphabetIndex |= subRegionBitMasks[bitMaskIndex]
            }
            
            bitMaskIndex += 1
            if bitMaskIndex == subRegionBitMasks.count {
                hash.append(alphabet[alphabetIndex])
                bitMaskIndex = 0
                alphabetIndex = 0
            }
        }
        
        return hash
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
