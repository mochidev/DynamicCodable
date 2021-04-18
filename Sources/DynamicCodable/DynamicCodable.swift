//
//  DynamicCodable.swift
//  DynamicCodable
//
//  Created by Dimitri Bouniol on 4/17/21.
//  Copyright © 2021 Mochi Development, Inc. All rights reserved.
//

/// `DynamicCodable` is an in-memory representation of unarchived data. On it's own, it can be be used to preserve archived content, or inspected dynamically should all cases be gracefully handled.
/// - Tag: DynamicCodable
public enum DynamicCodable: Equatable, Hashable {
    /// A value coded using a keyed container such as a dictionary.
    /// - Tag: DynamicCodable.keyed
    case keyed([Key : Self])
    
    /// A value coded using a keyed container such as an array.
    /// - Tag: DynamicCodable.unkeyed
    case unkeyed([Self])
    
    /// A value coding nil as a single value container.
    /// - Tag: DynamicCodable.nil
    case `nil`
    
    /// A value coding a `Bool` as a single value container.
    /// - Tag: DynamicCodable.bool
    case bool(Bool)
    
    /// A value coding a `String` as a single value container.
    /// - Tag: DynamicCodable.string
    case string(String)
    
    /// A value coding a `Float64` as a single value container.
    /// - Tag: DynamicCodable.float64
    case float64(Float64)
    
    /// A value coding a `Float32` as a single value container.
    /// - Tag: DynamicCodable.float32
    case float32(Float32)
    
    /// A value coding an `Int` as a single value container.
    /// - Tag: DynamicCodable.int
    case int(Int)
    
    /// A value coding an `Int8` as a single value container.
    /// - Tag: DynamicCodable.int8
    case int8(Int8)
    
    /// A value coding an `Int16` as a single value container.
    /// - Tag: DynamicCodable.int16
    case int16(Int16)
    
    /// A value coding an `Int32` as a single value container.
    /// - Tag: DynamicCodable.int32
    case int32(Int32)
    
    /// A value coding an `Int64` as a single value container.
    /// - Tag: DynamicCodable.int64
    case int64(Int64)
    
    /// A value coding a `UInt` as a single value container.
    /// - Tag: DynamicCodable.uint
    case uint(UInt)
    
    /// A value coding a `UInt8` as a single value container.
    /// - Tag: DynamicCodable.uint8
    case uint8(UInt8)
    
    /// A value coding a `UInt16` as a single value container.
    /// - Tag: DynamicCodable.uint16
    case uint16(UInt16)
    
    /// A value coding a `UInt32` as a single value container.
    /// - Tag: DynamicCodable.uint32
    case uint32(UInt32)
    
    /// A value coding a `UInt64` as a single value container.
    /// - Tag: DynamicCodable.uint64
    case uint64(UInt64)
    
    /// A (rare) value coding an empty single value container. Only certain decoders may even support this.
    /// - Tag: DynamicCodable.empty
    case empty
}

extension DynamicCodable {
    /// A convenience case for creating a [float32 case](x-source-tag://DynamicCodable.float32).
    /// - Parameter float: The float to represent.
    /// - Returns: DynamicCodable.float32
    /// - Tag: DynamicCodable.float
    @inlinable
    public static func float(_ float: Float) -> Self { .float32(float) }
    
    /// A convenience case for creating a [float64 case](x-source-tag://DynamicCodable.float64).
    /// - Parameter float: The float to represent.
    /// - Returns: DynamicCodable.float64
    /// - Tag: DynamicCodable.double
    @inlinable
    public static func double(_ double: Double) -> Self { .float64(double) }
}
