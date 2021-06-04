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
    case keyed(Keyed)
    
    /// A value coded using a keyed container such as an array.
    /// - Tag: DynamicCodable.unkeyed
    case unkeyed(Unkeyed)
    
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
    
    // MARK: - DynamicCodableTypes
    
    /// The underlying type for [.keyed](x-source-tag://DynamicCodable.keyed) values.
    /// - Tag: DynamicCodable.Keyed
    public typealias Keyed = [DynamicCodable.Key : DynamicCodable]
    
    /// The underlying type for [.unkeyed](x-source-tag://DynamicCodable.unkeyed) values.
    /// - Tag: DynamicCodable.Unkeyed
    public typealias Unkeyed = [DynamicCodable]
    
    /// The underlying type for [.nil](x-source-tag://DynamicCodable.nil) values.
    /// - Tag: DynamicCodable.Nil
    public typealias Nil = Optional<Any>
    
    /// The underlying type for [.bool](x-source-tag://DynamicCodable.bool) values.
    /// - Tag: DynamicCodable.Bool
    public typealias Bool = Swift.Bool
    
    /// The underlying type for [.string](x-source-tag://DynamicCodable.string) values.
    /// - Tag: DynamicCodable.String
    public typealias String = Swift.String
    
    /// The underlying type for [.float64](x-source-tag://DynamicCodable.float64) values.
    /// - Tag: DynamicCodable.Float64
    public typealias Float64 = Swift.Float64
    
    /// The underlying type for [.float32](x-source-tag://DynamicCodable.float32) values.
    /// - Tag: DynamicCodable.Float32
    public typealias Float32 = Swift.Float32
    
    /// The underlying type for [.int](x-source-tag://DynamicCodable.int) values.
    /// - Tag: DynamicCodable.Int
    public typealias Int = Swift.Int
    
    /// The underlying type for [.int8](x-source-tag://DynamicCodable.int8) values.
    /// - Tag: DynamicCodable.Int8
    public typealias Int8 = Swift.Int8
    
    /// The underlying type for [.int16](x-source-tag://DynamicCodable.int16) values.
    /// - Tag: DynamicCodable.Int16
    public typealias Int16 = Swift.Int16
    
    /// The underlying type for [.int32](x-source-tag://DynamicCodable.int32) values.
    /// - Tag: DynamicCodable.Int32
    public typealias Int32 = Swift.Int32
    
    /// The underlying type for [.int64](x-source-tag://DynamicCodable.int64) values.
    /// - Tag: DynamicCodable.Int64
    public typealias Int64 = Swift.Int64
    
    /// The underlying type for [.uint](x-source-tag://DynamicCodable.uint) values.
    /// - Tag: DynamicCodable.UInt
    public typealias UInt = Swift.UInt
    
    /// The underlying type for [.uint8](x-source-tag://DynamicCodable.uint8) values.
    /// - Tag: DynamicCodable.UInt8
    public typealias UInt8 = Swift.UInt8
    
    /// The underlying type for [.uint16](x-source-tag://DynamicCodable.uint16) values.
    /// - Tag: DynamicCodable.UInt16
    public typealias UInt16 = Swift.UInt16
    
    /// The underlying type for [.uint32](x-source-tag://DynamicCodable.uint32) values.
    /// - Tag: DynamicCodable.UInt32
    public typealias UInt32 = Swift.UInt32
    
    /// The underlying type for [.uint64](x-source-tag://DynamicCodable.uint64) values.
    /// - Tag: DynamicCodable.UInt64
    public typealias UInt64 = Swift.UInt64
    
    /// The underlying type for [.empty](x-source-tag://DynamicCodable.empty) values.
    /// - Tag: DynamicCodable.Empty
    public typealias Empty = Swift.Void
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
