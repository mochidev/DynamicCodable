//
//  DynamicCodable+Codable.swift
//  DynamicCodable
//
//  Created by Dimitri Bouniol on 4/17/21.
//  Copyright © 2021 Mochi Development, Inc. All rights reserved.
//

extension DynamicCodable: Decodable {
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: Key.self) {
            let allKeys = container.allKeys
            var keyed: [Key : Self] = [:]
            keyed.reserveCapacity(allKeys.count)
            for key in allKeys {
                keyed[key] = try container.decode(Self.self, forKey: key)
            }
            self = .keyed(keyed)
            
        } else if var container = try? decoder.unkeyedContainer() {
            var unkeyed: [Self] = []
            if let count = container.count {
                unkeyed.reserveCapacity(count)
            }
            while !container.isAtEnd {
                unkeyed.append(try container.decode(Self.self))
            }
            self = .unkeyed(unkeyed)
            
        } else if let container = try? decoder.singleValueContainer() {
            if container.decodeNil() {
                self = .nil
            } else if let bool = try? container.decode(Bool.self) {
                self = .bool(bool)
            } else if let string = try? container.decode(String.self) {
                self = .string(string)
                
            // Decode Int types before Float types, or else all numbers will be respresented by Float types.
            } else if let int = try? container.decode(Int.self) {
                self = .int(int)
            } else if let uint = try? container.decode(UInt.self) {
                self = .uint(uint)
                
            /// If Int/UInt was not decodable, the Decoder might be picky. Start with smallest Int types first, going larger at each step of the way until the correct type is found before relying on Float types.
            } else if let int8 = try? container.decode(Int8.self) {
                self = .int8(int8)
            } else if let int16 = try? container.decode(Int16.self) {
                self = .int16(int16)
            } else if let int32 = try? container.decode(Int32.self) {
                self = .int32(int32)
            } else if let int64 = try? container.decode(Int64.self) {
                self = .int64(int64)
            } else if let uint8 = try? container.decode(UInt8.self) {
                self = .uint8(uint8)
            } else if let uint16 = try? container.decode(UInt16.self) {
                self = .uint16(uint16)
            } else if let uint32 = try? container.decode(UInt32.self) {
                self = .uint32(uint32)
            } else if let uint64 = try? container.decode(UInt64.self) {
                self = .uint64(uint64)
                
            /// Decode largest Float types first, going smaller from there.
            } else if let float64 = try? container.decode(Double.self) {
                self = .float64(float64)
            } else if let float32 = try? container.decode(Float.self) {
                self = .float32(float32)
            
            /// We've decoded every type, but somehow ended up here. Log, but don't crash, as new types may have been added.
            } else {
                print("We've reached the end of the singleValueContainer() \(container), but no primitive value was decoded. You may need to update DynamicCodable to decode this value, or please file a bug at https://github.com/mochidev/DynamicCodable. `DynamicCodable.empty` will be used instead.")
                self = .empty
            }
            
        } else {
            self = .empty
        }
    }
}

extension DynamicCodable: Encodable {
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .keyed(let keyed):
            var container = encoder.container(keyedBy: Key.self)
            for (key, value) in keyed {
                try container.encode(value, forKey: key)
            }
        case .unkeyed(let unkeyed):
            var container = encoder.unkeyedContainer()
            for value in unkeyed {
                try container.encode(value)
            }
        case .nil:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        case .bool(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .string(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .float64(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .float32(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .int(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .int8(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .int16(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .int32(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .int64(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .uint(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .uint8(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .uint16(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .uint32(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .uint64(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .empty: break
        }
    }
}
