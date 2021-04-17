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
    
    func testSubscripts() {
        var test: [DynamicCodable.Key : DynamicCodable] = [
            .string("A"): .string("a"),
            .int(1): .int(1),
            .string("1"): .string("1")
        ]
        
        XCTAssertEqual(test[.string("A")], .string("a"))
        XCTAssertEqual(test["A"], .string("a"))
        XCTAssertEqual(test["1"], .string("1"))
        XCTAssertNotEqual(test["1"], .int(1))
        XCTAssertEqual(test[1], .int(1))
        XCTAssertNotEqual(test[1], .string("1"))
        XCTAssertNil(test["B"])
        XCTAssertEqual(test["B", default: .empty], .empty)
        XCTAssertNil(test[2])
        XCTAssertEqual(test[2, default: .empty], .empty)
        
        test["B"] = .string("b")
        XCTAssertEqual(test[.string("B")], .string("b"))
        
        test[2] = .int(2)
        XCTAssertEqual(test[.int(2)], .int(2))
    }
}
