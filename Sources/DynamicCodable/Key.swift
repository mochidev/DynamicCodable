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
