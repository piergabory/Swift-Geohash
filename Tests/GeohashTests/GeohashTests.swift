import XCTest
@testable import Geohash

final class GeoHashTests: XCTestCase {
    
    private let geohashes = [
        "6gkzwgjt":     (-25.383, -49.266, 3),
        "6gkzwgjzn820": (-25.382708, -49.265506, 6),
        "6gkzmg1u":     (-25.427, -49.315, 3),
        "qd66hrhk":     (-31.953, 115.857, 3),
        "dqcjqcp84c6e": (38.89710201881826, -77.03669792041183, 14),
        "ezs42":        (42.6, -5.6, 1),
    ]
    
    func testEncoding() {
        for (hash, (latitude, longitude, _)) in geohashes {
            XCTAssertEqual(hash, Geohash.encode(latitude: latitude, longitude: longitude, precision: hash.count).string)
        }
    }
    
    func testDecoding() {
        for (hash, (latitude, longitude, decimalPrecision)) in geohashes {
            let accuracy = pow(10, Double(-decimalPrecision))
            do {
                let result = try Geohash.decode(string: hash)
                XCTAssertEqual(result.latitudeMidPoint, latitude, accuracy: accuracy)
                XCTAssertEqual(result.longitudeMidPoint, longitude, accuracy: accuracy)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }

    static var allTests = [
        ("testEncoding", testEncoding),
        ("testDecoding", testDecoding),
    ]
}
