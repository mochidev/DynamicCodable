import XCTest
@testable import DynamicCodable

final class DynamicCodableTests: XCTestCase {
    func testEquality() {
        XCTAssertEqual(DynamicCodable.empty, .empty)
        XCTAssertNotEqual(DynamicCodable.empty, .nil)
        XCTAssertEqual(DynamicCodable.unkeyed([.nil]), .unkeyed([.nil]))
        XCTAssertNotEqual(DynamicCodable.unkeyed([]), .unkeyed([.nil]))
    }
}
