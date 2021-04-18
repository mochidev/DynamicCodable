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
    
    func testLiterals() {
        let test: DynamicCodable = nil
        XCTAssertEqual(test, .nil) // Make sure XCTAssertEqual doesn't mis-interpret nil
        
        XCTAssertEqual(DynamicCodable.int(5), 5)
        XCTAssertEqual(DynamicCodable.float64(5.5), 5.5)
        XCTAssertEqual(DynamicCodable.bool(true), true)
        XCTAssertEqual(DynamicCodable.bool(false), false)
        XCTAssertEqual(DynamicCodable.string("A"), "A")
        XCTAssertEqual(DynamicCodable.string("1"), "\(1)")
        XCTAssertEqual(
            DynamicCodable.unkeyed(
                [
                    .empty,
                    .nil,
                    .bool(true),
                    .int(5),
                    .float64(5.5),
                    .string("A")
                ]
            ), [
                .empty,
                nil,
                true,
                5,
                5.5,
                "A"
            ]
        )
        XCTAssertEqual(
            DynamicCodable.keyed(
                [
                    .string("A"): .string("A"),
                    .int(1): .int(1),
                    .string("1"): .string("2")
                ]
            ), [
                "A": "A",
                1: 1,
                "1": "2"
            ]
        )
    }
    
    func testPrimitiveDecoding() {
        do {
            let data = """
            {
            }
            """.data(using: .utf8)!
            
            let testRepresentation: DynamicCodable = [:]
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let data = """
            [
            ]
            """.data(using: .utf8)!
            
            let testRepresentation: DynamicCodable = []
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let data = """
            null
            """.data(using: .utf8)!
            
            let testRepresentation: DynamicCodable = nil
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let data = """
            true
            """.data(using: .utf8)!
            
            let testRepresentation: DynamicCodable = true
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let data = """
            false
            """.data(using: .utf8)!
            
            let testRepresentation: DynamicCodable = false
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let data = """
            "string"
            """.data(using: .utf8)!
            
            let testRepresentation: DynamicCodable = "string"
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let data = """
            1
            """.data(using: .utf8)!
            
            let testRepresentation: DynamicCodable = 1
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let data = """
            \(UInt(Int.max)+1)
            """.data(using: .utf8)!
            
            let testRepresentation: DynamicCodable = .uint(UInt(Int.max)+1)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        // On 32-bit systems, also verify that large enough values get decoded into a .uint64
        if MemoryLayout<UInt>.size != 8 {
            do {
                let data = """
                \(UInt64(Int64.max)+1)
                """.data(using: .utf8)!
                
                let testRepresentation: DynamicCodable = .uint64(UInt64(Int64.max)+1)
                
                let decoder = JSONDecoder()
                let representation = try decoder.decode(DynamicCodable.self, from: data)
                XCTAssertEqual(representation, testRepresentation)
            } catch {
                XCTFail("Error occurred: \(error)")
            }
        }
        
        do {
            let data = """
                18446744073709551616
                """.data(using: .utf8)!
            
            let testRepresentation: DynamicCodable = .float64(Double(UInt64.max)+1)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let data = """
            3.14
            """.data(using: .utf8)!
            
            let testRepresentation: DynamicCodable = 3.14
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
    }
    
    func testComplexDecoding() {
        do {
            let data = """
            {
                "keyed": {
                    "simple": {
                        "A": "a",
                        "B": "b"
                    },
                    "int": {
                        "0": "a",
                        "1": 1,
                        "2": "1"
                    }
                },
                "unkeyed": {
                    "simple": [
                        0,
                        1
                    ],
                    "mixed": [
                        0,
                        true,
                        null
                    ]
                },
                "nil": null,
                "bool": {
                    "true": true,
                    "false": false
                },
                "string": "Hello",
                "float": 3.14,
                "int": 314
            }
            """.data(using: .utf8)!
            
            let testRepresentation: DynamicCodable = [
                "keyed": [
                    "simple": [
                        "A": "a",
                        "B": "b"
                    ],
                    "int": [
                        "0": "a",
                        "1": 1,
                        "2": "1"
                    ],
                ],
                "unkeyed": [
                    "simple": [
                        0,
                        1
                    ],
                    "mixed": [
                        0,
                        true,
                        nil
                    ],
                ],
                "nil": nil,
                "bool": [
                    "true": true,
                    "false": false
                ],
                "string": "Hello",
                "float": 3.14,
                "int": 314
            ]
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        // Int keys are currently not supported by the JSON decoder it seems.
//        do {
//            let data = """
//            {
//                "int": {
//                    0: "a",
//                    1: 1,
//                    2: "1"
//                }
//            }
//            """.data(using: .utf8)!
//
//            let testRepresentation: DynamicCodable = [
//                "int": [
//                    0: "a",
//                    1: 1,
//                    2: "1"
//                ]
//            ]
//
//            let decoder = JSONDecoder()
//            let representation = try decoder.decode(DynamicCodable.self, from: data)
//            XCTAssertEqual(representation, testRepresentation)
//        } catch {
//            XCTFail("Error occurred: \(error)")
//        }
        
        do {
            struct ServerResponse: Equatable, Codable {
                let status: String
                let metadata: DynamicCodable
            }
            
            let data = """
            {
                "status": "enabled",
                "metadata": {
                    "simple": [
                        0,
                        1
                    ],
                    "mixed": [
                        0,
                        true,
                        null
                    ]
                }
            }
            """.data(using: .utf8)!
            
            let testRepresentation = ServerResponse(
                status: "enabled",
                metadata: [
                    "simple": [
                        0,
                        1
                    ],
                    "mixed": [
                        0,
                        true,
                        nil
                    ],
                ]
            )
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(ServerResponse.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
    }
    
    func testPrimitiveEncoding() {
        do {
            let testRepresentation: DynamicCodable = [:]
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(testRepresentation)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let testRepresentation: DynamicCodable = []
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(testRepresentation)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let testRepresentation: DynamicCodable = nil
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(testRepresentation)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let testRepresentation: DynamicCodable = true
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(testRepresentation)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let testRepresentation: DynamicCodable = false
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(testRepresentation)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let testRepresentation: DynamicCodable = "string"
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(testRepresentation)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let testRepresentation: DynamicCodable = 1
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(testRepresentation)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let testRepresentation: DynamicCodable = .uint(UInt(Int.max)+1)
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(testRepresentation)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        // On 32-bit systems, also verify that large enough values get decoded into a .uint64
        if MemoryLayout<UInt>.size != 8 {
            do {
                let testRepresentation: DynamicCodable = .uint64(UInt64(Int64.max)+1)
                
                let encoder = JSONEncoder()
                let data = try encoder.encode(testRepresentation)
                
                let decoder = JSONDecoder()
                let representation = try decoder.decode(DynamicCodable.self, from: data)
                XCTAssertEqual(representation, testRepresentation)
            } catch {
                XCTFail("Error occurred: \(error)")
            }
        }
        
        do {
            let testRepresentation: DynamicCodable = .float64(Double(UInt64.max)+1)
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(testRepresentation)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let testRepresentation: DynamicCodable = 3.14
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(testRepresentation)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
    }
    
    func testComplexEncoding() {
        do {
            let testRepresentation: DynamicCodable = [
                "keyed": [
                    "simple": [
                        "A": "a",
                        "B": "b"
                    ],
                    "int": [
                        "0": "a",
                        "1": 1,
                        "2": "1"
                    ],
                ],
                "unkeyed": [
                    "simple": [
                        0,
                        1
                    ],
                    "mixed": [
                        0,
                        true,
                        nil
                    ],
                ],
                "nil": nil,
                "bool": [
                    "true": true,
                    "false": false
                ],
                "string": "Hello",
                "float": 3.14,
                "int": 314
            ]
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(testRepresentation)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        // Int keys are currently not supported by the JSON decoder it seems.
        do {
            let testRepresentation: DynamicCodable = [
                "int": [
                    0: "a",
                    1: 1,
                    2: "1"
                ]
            ]
            let stringRepresentation: DynamicCodable = [
                "int": [
                    "0": "a",
                    "1": 1,
                    "2": "1"
                ]
            ]
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(testRepresentation)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertNotEqual(representation, testRepresentation)
            XCTAssertEqual(representation, stringRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        // Int keys are currently not supported by the PropertyList decoder it seems.
        do {
            let testRepresentation: DynamicCodable = [
                "int": [
                    0: "a",
                    1: 1,
                    2: "1"
                ]
            ]
            let stringRepresentation: DynamicCodable = [
                "int": [
                    "0": "a",
                    "1": 1,
                    "2": "1"
                ]
            ]
            
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            let data = try encoder.encode(testRepresentation)
            
            let decoder = PropertyListDecoder()
            let representation = try decoder.decode(DynamicCodable.self, from: data)
            XCTAssertNotEqual(representation, testRepresentation)
            XCTAssertEqual(representation, stringRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
        
        do {
            let testRepresentation: DynamicCodable = .empty
            
            let encoder = JSONEncoder()
            _ = try encoder.encode(testRepresentation)
            
            XCTFail("The JSON encoder should have failed here!")
        } catch {
            
        }
        
        do {
            let testRepresentation: DynamicCodable = .empty
            
            let encoder = PropertyListEncoder()
            _ = try encoder.encode(testRepresentation)
            
            XCTFail("The PropertyList encoder should have failed here!")
        } catch {
            
        }
        
        do {
            struct ServerResponse: Equatable, Codable {
                let status: String
                let metadata: DynamicCodable
            }
            
            let testRepresentation = ServerResponse(
                status: "enabled",
                metadata: [
                    "simple": [
                        0,
                        1
                    ],
                    "mixed": [
                        0,
                        true,
                        nil
                    ],
                ]
            )
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(testRepresentation)
            
            let decoder = JSONDecoder()
            let representation = try decoder.decode(ServerResponse.self, from: data)
            XCTAssertEqual(representation, testRepresentation)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
    }
}
