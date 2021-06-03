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
    func unwrap<T>(errorHandler: () throws -> T) rethrows -> T {
        switch T.self {
        case is Keyed.Type:     if case .keyed(let keyed) = self        { return unsafeBitCast(keyed,       to: T.self) }
        case is Unkeyed.Type:   if case .unkeyed(let unkeyed) = self    { return unsafeBitCast(unkeyed,     to: T.self) }
        case is Nil.Type:       if case .nil = self                     { return unsafeBitCast(Nil.none,    to: T.self) }
        case is Bool.Type:      if case .bool(let bool) = self          { return unsafeBitCast(bool,        to: T.self) }
        case is String.Type:    if case .string(let string) = self      { return unsafeBitCast(string,      to: T.self) }
        case is Float64.Type:   if case .float64(let float64) = self    { return unsafeBitCast(float64,     to: T.self) }
        case is Float32.Type:   if case .float64(let float32) = self    { return unsafeBitCast(float32,     to: T.self) }
        case is Int.Type:       if case .int(let int) = self            { return unsafeBitCast(int,         to: T.self) }
        case is Int8.Type:      if case .int8(let int8) = self          { return unsafeBitCast(int8,        to: T.self) }
        case is Int16.Type:     if case .int16(let int16) = self        { return unsafeBitCast(int16,       to: T.self) }
        case is Int32.Type:     if case .int32(let int32) = self        { return unsafeBitCast(int32,       to: T.self) }
        case is Int64.Type:     if case .int64(let int64) = self        { return unsafeBitCast(int64,       to: T.self) }
        case is UInt.Type:      if case .uint(let uint) = self          { return unsafeBitCast(uint,        to: T.self) }
        case is UInt8.Type:     if case .uint8(let uint8) = self        { return unsafeBitCast(uint8,       to: T.self) }
        case is UInt16.Type:    if case .uint16(let uint16) = self      { return unsafeBitCast(uint16,      to: T.self) }
        case is UInt32.Type:    if case .uint32(let uint32) = self      { return unsafeBitCast(uint32,      to: T.self) }
        case is UInt64.Type:    if case .uint64(let uint64) = self      { return unsafeBitCast(uint64,      to: T.self) }
        case is Empty.Type:     if case .empty = self                   { return unsafeBitCast((),          to: T.self) }
        default: break // TODO: We should do something different here, so we can ignore this case in the caller. Perhaps return a specialized error?
        }
        
        return try errorHandler()
    }
}
