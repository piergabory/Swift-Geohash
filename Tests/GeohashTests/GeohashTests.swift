import XCTest
@testable import Geohash

final class GeohashTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Geohash().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
