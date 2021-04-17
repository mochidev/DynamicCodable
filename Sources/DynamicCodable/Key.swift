//
//  Key.swift
//  DynamicCodable
//
//  Created by Dimitri Bouniol on 4/17/21.
//  Copyright © 2021 Mochi Development, Inc. All rights reserved.
//

extension DynamicCodable {
    /// A key that may be used in [DynamicCodable](x-source-tag://DynamicCodable) [keyed cases](x-source-tag://DynamicCodable.keyed).
    /// This corresponds to the types CodingKey can currently represent.
    /// - Tag: DynamicCodable.Key
    public enum Key: Equatable, Hashable, Comparable {
        /// An integer key, represented by the associated value.
        /// - Tag: DynamicCodable.Key.int
        case int(Int)
        
        /// A string key, represented by the associated value.
        /// - Tag: DynamicCodable.Key.string
        case string(String)
        
        /// DynamicCodable.Key customizes the hash function so it can simply fall back on the associated type's implementation.
        @inlinable
        public func hash(into hasher: inout Hasher) {
            switch self {
            case .string(let stringValue):
                stringValue.hash(into: &hasher)
            case .int(let intValue):
                intValue.hash(into: &hasher)
            }
        }
    }
}

extension DynamicCodable.Key: CodingKey {
    public var stringValue: String {
        switch self {
        case .string(let stringValue):
            return stringValue
        case .int(let intValue):
            return String(intValue)
        }
    }
    
    public init?(stringValue: String) {
        self = .string(stringValue)
    }
    
    public var intValue: Int? {
        switch self {
        case .string(_):
            return nil
        case .int(let intValue):
            return intValue
        }
    }
    
    public init?(intValue: Int) {
        self = .int(intValue)
    }
}

extension Dictionary where Key == DynamicCodable.Key, Value == DynamicCodable {
    /// A convenience accessor for getting or setting the value for a [.string(…)](x-source-tag://DynamicCodable.Key.string) key.
    /// - Parameter key: The `String` key to find in the dictionary.
    /// - Returns: The value associated with `.string(key)` in the dictionary.
    @inlinable
    public subscript(key: String) -> DynamicCodable? {
        get {
            self[.string(key)]
        }
        set(newValue) {
            self[.string(key)] = newValue
        }
    }
    
    /// A convenience accessor for getting the value for a [.string(…)](x-source-tag://DynamicCodable.Key.string) key, returning `defaultValue` if .
    /// - Parameter key: The `String` key to find in the dictionary.
    /// - Parameter defaultValue: The default value to use if `key` doesn't exist in the dictionary.
    /// - Returns: The value associated with `.string(key)` in the dictionary; otherwise, `defaultValue`.
    @inlinable public subscript(key: String, default defaultValue: @autoclosure () -> DynamicCodable) -> DynamicCodable {
        self[.string(key)] ?? defaultValue()
    }
    
    /// A convenience accessor for getting or setting the value for a [.int(…)](x-source-tag://DynamicCodable.Key.int) key.
    /// - Parameter key: The `Int` key to find in the dictionary.
    /// - Returns: The value associated with `.int(key)` in the dictionary.
    @inlinable
    public subscript(key: Int) -> DynamicCodable? {
        get {
            self[.int(key)]
        }
        set(newValue) {
            self[.int(key)] = newValue
        }
    }
    
    /// A convenience accessor for getting the value for a [.int(…)](x-source-tag://DynamicCodable.Key.int) key.
    /// - Parameter key: The `Int` key to find in the dictionary.
    /// - Parameter defaultValue: The default value to use if `key` doesn't exist in the dictionary. 
    /// - Returns: The value associated with `.int(key)` in the dictionary; otherwise, `defaultValue`.
    @inlinable public subscript(key: Int, default defaultValue: @autoclosure () -> DynamicCodable) -> DynamicCodable {
        self[.int(key)] ?? defaultValue()
    }
}
