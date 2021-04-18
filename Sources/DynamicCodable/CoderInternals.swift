//
//  CoderInternals.swift
//  DynamicCodable
//
//  Created by Dimitri Bouniol on 4/18/21.
//  Copyright © 2021 Mochi Development, Inc. All rights reserved.
//

extension Dictionary where Key == DynamicCodable.Key, Value == DynamicCodable {
    @inline(__always)
    subscript(key: CodingKey) -> DynamicCodable? {
        if let intKey = key.intValue, let value = self[intKey] {
            return value
        } else if let value = self[key.stringValue] {
            return value
        }
        return nil
    }
}

struct DynamicCoderCodingKey: CodingKey {
    public var stringValue: String
    public var intValue: Int?
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    public init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
    
    init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }
    
    static let `super` = DynamicCoderCodingKey(stringValue: "super", intValue: nil)
}

extension DynamicCodable {
    var debugDataTypeDescription: String {
        switch self {
        case .keyed(_):     return "a keyed container"
        case .unkeyed(_):   return "an unkeyed container"
        case .nil:          return "nil"
        case .bool(_):      return "a boolean"
        case .string(_):    return "a string"
        case .float64(_):   return "a float64"
        case .float32(_):   return "a float32"
        case .int(_):       return "an int"
        case .int8(_):      return "an int8"
        case .int16(_):     return "an int16"
        case .int32(_):     return "an int32"
        case .int64(_):     return "an int64"
        case .uint(_):      return "a uint"
        case .uint8(_):     return "a uint8"
        case .uint16(_):    return "a uint16"
        case .uint32(_):    return "a uint32"
        case .uint64(_):    return "a uint64"
        case .empty:        return "an empty container"
        }
    }
    
    @inline(__always)
    func unwrap<T>(errorHandler: () throws -> Never) rethrows -> T {
        let value: Any
        
        switch self {
        case .keyed(let keyed):     value = keyed
        case .unkeyed(let unkeyed): value = unkeyed
        case .nil:                  value = Nil.none as Any
        case .bool(let bool):       value = bool
        case .string(let string):   value = string
        case .float64(let float64): value = float64
        case .float32(let float32): value = float32
        case .int(let int):         value = int
        case .int8(let int8):       value = int8
        case .int16(let int16):     value = int16
        case .int32(let int32):     value = int32
        case .int64(let int64):     value = int64
        case .uint(let uint):       value = uint
        case .uint8(let uint8):     value = uint8
        case .uint16(let uint16):   value = uint16
        case .uint32(let uint32):   value = uint32
        case .uint64(let uint64):   value = uint64
        case .empty:                value = ()
        }
        
        guard let value = value as? T else { try errorHandler() }
        return value
    }
}
