import XCTest
@testable import DynamicCodable

final class DynamicCodableTests: XCTestCase {
    func testEquality() {
        XCTAssertEqual(DynamicCodable.empty, .empty)
        XCTAssertNotEqual(DynamicCodable.empty, .nil)
        XCTAssertEqual(DynamicCodable.unkeyed([.nil]), .unkeyed([.nil]))
        XCTAssertNotEqual(DynamicCodable.unkeyed([]), .unkeyed([.nil]))
        XCTAssertEqual(DynamicCodable.float(5.2), .float32(5.2))
        XCTAssertEqual(DynamicCodable.double(12.5), .float64(12.5))
    }
}
