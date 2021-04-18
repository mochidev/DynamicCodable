//
//  DynamicCodableDecoder.swift
//  DynamicCodable
//
//  Created by Dimitri Bouniol on 4/17/21.
//  Copyright © 2021 Mochi Development, Inc. All rights reserved.
//

/// `DynamicCodableDecoder` facilitates the decoding of [DynamicCodable](x-source-tag://DynamicCodable) representations into semantic `Decodable` types.
/// - Tag: DynamicCodableDecoder
open class DynamicCodableDecoder {
    // MARK: Options
    
    /// Contextual user-provided information for use during decoding.
    /// - Tag: DynamicCodableDecoder.userInfo
    open var userInfo: [CodingUserInfoKey: Any] = [:]
    
    /// Options set on the top-level encoder to pass down the decoding hierarchy.
    /// - Tag: DynamicCodableDecoder.Options
    fileprivate struct Options {
        /// - Tag: DynamicCodableDecoder.Options.userInfo
        let userInfo: [CodingUserInfoKey: Any]
    }
    
    /// The options set on the top-level decoder.
    /// - Tag: DynamicCodableDecoder.options
    fileprivate var options: Options {
        return Options(
            userInfo: userInfo
        )
    }
    
    // MARK: - Constructing a DynamicCodable Decoder
    /// Initializes `self` with default strategies.
    /// - Tag: DynamicCodableDecoder.init
    public init() {}
    
    // MARK: - Decoding Values
    /// Decodes a top-level value of the given type from the given [DynamicCodable](x-source-tag://DynamicCodable) representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter data: The data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: An error if any value throws an error during decoding.
    /// - Tag: DynamicCodableDecoder.decode
    open func decode<T: Decodable>(_ type: T.Type, from representation: DynamicCodable) throws -> T {
        try Decoder(from: representation, codingPath: [], options: options).unwrap()
    }
}

// MARK: - Decoder

extension DynamicCodableDecoder {
    fileprivate struct Decoder {
        let codingPath: [CodingKey]
        
        let representation: DynamicCodable
        let options: Options
        
        init(from representation: DynamicCodable, codingPath: [CodingKey], options: Options) {
            self.codingPath = codingPath
            self.representation = representation
            self.options = options
        }
        
        func appending(_ key: CodingKey, newValue: DynamicCodable) -> Self {
            Self(from: newValue, codingPath: codingPath + [key], options: options)
        }
    }
}

extension DynamicCodableDecoder.Decoder: Swift.Decoder {
    var userInfo: [CodingUserInfoKey: Any] { options.userInfo }
    
    @usableFromInline
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        guard case .keyed(let keyedRepresentation) = representation else {
            throw createTypeMismatchError(type: [DynamicCodable.Key : DynamicCodable].self)
        }
        
        let container = KeyedContainer<Key>(
            decoder: self,
            representation: keyedRepresentation
        )
        return KeyedDecodingContainer(container)
    }
    
    @usableFromInline
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard case .unkeyed(let unkeyedRepresentation) = representation else {
            throw createTypeMismatchError(type: [DynamicCodable].self)
        }
        
        return UnkeyedContainer(
            decoder: self,
            representation: unkeyedRepresentation
        )
    }
    
    @usableFromInline
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        SingleValueContainter(decoder: self)
    }
    
    @inline(__always)
    func unwrap<T: Decodable>() throws -> T {
        let value = representation
        let error = createTypeMismatchError(type: T.self)
        
        typealias Primitive = DynamicCodable
        
        switch T.self {
        // Return DynamicCodable as is if it is being decoded
        case is DynamicCodable.Type:    return unsafeBitCast(value, to: T.self)
        // Primitive Types fast-path
        case is Primitive.Keyed.Type,
             is Primitive.Unkeyed.Type,
             is Primitive.Nil.Type,
             is Primitive.Bool.Type,
             is Primitive.String.Type,
             is Primitive.Float64.Type,
             is Primitive.Float32.Type,
             is Primitive.Int.Type,
             is Primitive.Int8.Type,
             is Primitive.Int16.Type,
             is Primitive.Int32.Type,
             is Primitive.Int64.Type,
             is Primitive.UInt.Type,
             is Primitive.UInt8.Type,
             is Primitive.UInt16.Type,
             is Primitive.UInt32.Type,
             is Primitive.UInt64.Type,
             is Primitive.Empty.Type:   return try value.unwrap { throw error }
        // Decodable Types
        default:                        return try T(from: self)
        }
    }
    
    @inline(__always)
    private func unwrapFloatingPoint<T: BinaryFloatingPoint>() throws -> T {
        @inline(__always)
        func validate<T: BinaryFloatingPoint>(_ floatingPoint: T, originalValue: CustomStringConvertible) throws -> T {
            guard floatingPoint.isFinite else {
                throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: codingPath,
                        debugDescription: "Represented number <\(floatingPoint)> does not fit in \(T.self)."
                    )
                )
            }
            
            return floatingPoint
        }
        
        switch representation {
        case .float64(let number):  return try validate(T(number), originalValue: number)
        case .float32(let number):  return try validate(T(number), originalValue: number)
        case .int(let number):      return try validate(T(number), originalValue: number)
        case .int8(let number):     return try validate(T(number), originalValue: number)
        case .int16(let number):    return try validate(T(number), originalValue: number)
        case .int32(let number):    return try validate(T(number), originalValue: number)
        case .int64(let number):    return try validate(T(number), originalValue: number)
        case .uint(let number):     return try validate(T(number), originalValue: number)
        case .uint8(let number):    return try validate(T(number), originalValue: number)
        case .uint16(let number):   return try validate(T(number), originalValue: number)
        case .uint32(let number):   return try validate(T(number), originalValue: number)
        case .uint64(let number):   return try validate(T(number), originalValue: number)
            
        case .string,
             .bool,
             .keyed,
             .unkeyed,
             .empty,
             .nil:
            throw self.createTypeMismatchError(type: T.self)
        }
    }
    
    @inline(__always)
    private func unwrapFixedWidthInteger<T: FixedWidthInteger>() throws -> T {
        @inline(__always)
        func validate<T: FixedWidthInteger>(_ fixedWidthInteger: T?, originalValue: CustomStringConvertible) throws -> T {
            guard let fixedWidthInteger = fixedWidthInteger else {
                throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: codingPath,
                        debugDescription: "Represented number <\(originalValue)> does not fit in \(T.self)."
                    )
                )
            }
            
            return fixedWidthInteger
        }
        
        switch representation {
        case .int(let number):      return try validate(T(exactly: number), originalValue: number)
        case .int8(let number):     return try validate(T(exactly: number), originalValue: number)
        case .int16(let number):    return try validate(T(exactly: number), originalValue: number)
        case .int32(let number):    return try validate(T(exactly: number), originalValue: number)
        case .int64(let number):    return try validate(T(exactly: number), originalValue: number)
        case .uint(let number):     return try validate(T(exactly: number), originalValue: number)
        case .uint8(let number):    return try validate(T(exactly: number), originalValue: number)
        case .uint16(let number):   return try validate(T(exactly: number), originalValue: number)
        case .uint32(let number):   return try validate(T(exactly: number), originalValue: number)
        case .uint64(let number):   return try validate(T(exactly: number), originalValue: number)
        case .float64(let number):  return try validate(T(exactly: number), originalValue: number)
        case .float32(let number):  return try validate(T(exactly: number), originalValue: number)
        case .string,
             .bool,
             .keyed,
             .unkeyed,
             .empty,
             .nil:
            throw self.createTypeMismatchError(type: T.self)
        }
    }
    
    private func createTypeMismatchError(type: Any.Type) -> DecodingError {
        DecodingError.typeMismatch(
            type,
            .init(
                codingPath: codingPath,
                debugDescription: "Expected to decode \(type) but found \(representation.debugDataTypeDescription) instead."
            )
        )
    }
}

extension DynamicCodableDecoder.Decoder {
    struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        let decoder: DynamicCodableDecoder.Decoder
        let representation: [DynamicCodable.Key : DynamicCodable]
        
        var codingPath: [CodingKey] { decoder.codingPath }
        
        var allKeys: [Key] {
            representation.keys.compactMap { dynamicKey in
                switch dynamicKey {
                case .int(let int):
                    return Key(intValue: int)
                case .string(let string):
                    return Key(stringValue: string)
                }
            }
        }
        
        func contains(_ key: Key) -> Bool { representation[key] != nil }
        
        @inline(__always)
        private func getValue<Key: CodingKey, Result>(forKey key: Key, transform: (_ decoder: DynamicCodableDecoder.Decoder) throws -> Result) throws -> Result {
            guard let value = representation[key] else {
                throw DecodingError.keyNotFound(
                    key,
                    .init(
                        codingPath: codingPath,
                        debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."
                    )
                )
            }
            
            do {
                return try transform(decoder.appending(key, newValue: value))
            } catch {
                throw error
            }
        }
        
        func decodeNil(forKey key: Key) throws -> Bool                      { try getValue(forKey: key) { $0.representation == .nil } }
        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool      { try getValue(forKey: key) { try $0.unwrap() } }
        func decode(_ type: String.Type, forKey key: Key) throws -> String  { try getValue(forKey: key) { try $0.unwrap() } }
        
        func decode(_: Double.Type, forKey key: Key) throws -> Double       { try getValue(forKey: key) { try $0.unwrapFloatingPoint() } }
        func decode(_: Float.Type, forKey key: Key) throws -> Float         { try getValue(forKey: key) { try $0.unwrapFloatingPoint() } }
        
        func decode(_: Int.Type, forKey key: Key) throws -> Int             { try getValue(forKey: key) { try $0.unwrapFixedWidthInteger() } }
        func decode(_: Int8.Type, forKey key: Key) throws -> Int8           { try getValue(forKey: key) { try $0.unwrapFixedWidthInteger() } }
        func decode(_: Int16.Type, forKey key: Key) throws -> Int16         { try getValue(forKey: key) { try $0.unwrapFixedWidthInteger() } }
        func decode(_: Int32.Type, forKey key: Key) throws -> Int32         { try getValue(forKey: key) { try $0.unwrapFixedWidthInteger() } }
        func decode(_: Int64.Type, forKey key: Key) throws -> Int64         { try getValue(forKey: key) { try $0.unwrapFixedWidthInteger() } }
        func decode(_: UInt.Type, forKey key: Key) throws -> UInt           { try getValue(forKey: key) { try $0.unwrapFixedWidthInteger() } }
        func decode(_: UInt8.Type, forKey key: Key) throws -> UInt8         { try getValue(forKey: key) { try $0.unwrapFixedWidthInteger() } }
        func decode(_: UInt16.Type, forKey key: Key) throws -> UInt16       { try getValue(forKey: key) { try $0.unwrapFixedWidthInteger() } }
        func decode(_: UInt32.Type, forKey key: Key) throws -> UInt32       { try getValue(forKey: key) { try $0.unwrapFixedWidthInteger() } }
        func decode(_: UInt64.Type, forKey key: Key) throws -> UInt64       { try getValue(forKey: key) { try $0.unwrapFixedWidthInteger() } }
        
        func decode<T>(_: T.Type, forKey key: Key) throws -> T where T: Decodable   { try getValue(forKey: key) { try $0.unwrap() } }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
            try getValue(forKey: key) { try $0.container(keyedBy: type) }
        }
        
        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            try getValue(forKey: key) { try $0.unkeyedContainer() }
        }
        
        func superDecoder() throws -> Swift.Decoder                 { try getValue(forKey: DynamicCoderCodingKey.super) { $0 } }
        func superDecoder(forKey key: Key) throws -> Swift.Decoder  { try getValue(forKey: key) { $0 } }
    }
}

extension DynamicCodableDecoder.Decoder {
    struct UnkeyedContainer: UnkeyedDecodingContainer {
        let decoder: DynamicCodableDecoder.Decoder
        let representation: [DynamicCodable]
        
        var codingPath: [CodingKey] { decoder.codingPath }
        var count: Int?             { representation.count }
        var isAtEnd: Bool           { currentIndex >= representation.count }
        
        var currentIndex = 0
        
        struct DontIncrementButContinue<T>: Error {
            var value: T
        }
        
        @inline(__always)
        private mutating func getNextValue<Result>(transform: (_ decoder: DynamicCodableDecoder.Decoder) throws -> Result) throws -> Result {
            guard !self.isAtEnd else {
                var message = "Unkeyed container is at end."
                if Result.self == UnkeyedContainer.self {
                    message = "Cannot get nested unkeyed container -- unkeyed container is at end."
                }
                if Result.self == Swift.Decoder.self {
                    message = "Cannot get superDecoder() -- unkeyed container is at end."
                }
                
                throw DecodingError.valueNotFound(
                    Result.self,
                    .init(
                        codingPath: codingPath + [DynamicCoderCodingKey(index: currentIndex)],
                        debugDescription: message,
                        underlyingError: nil
                    )
                )
            }
            
            do {
                let result = try transform(decoder.appending(DynamicCoderCodingKey(index: currentIndex), newValue: representation[currentIndex]))
                currentIndex += 1
                return result
            } catch let error as DontIncrementButContinue<Result> {
                return error.value
            } catch {
                throw error
            }
        }
        
        mutating func decodeNil() throws -> Bool {
            try getNextValue { decoder in
                // The protocol states: If the value is not null, does not increment currentIndex.
                if decoder.representation != .nil { throw DontIncrementButContinue(value: false) }
                return true
            }
        }
        
        mutating func decode(_ type: Bool.Type) throws -> Bool      { try getNextValue { try $0.unwrap() } }
        mutating func decode(_ type: String.Type) throws -> String  { try getNextValue { try $0.unwrap() } }
        
        mutating func decode(_: Double.Type) throws -> Double   { try getNextValue { try $0.unwrapFloatingPoint() } }
        mutating func decode(_: Float.Type) throws -> Float     { try getNextValue { try $0.unwrapFloatingPoint() } }
        
        mutating func decode(_: Int.Type) throws -> Int         { try getNextValue { try $0.unwrapFixedWidthInteger() } }
        mutating func decode(_: Int8.Type) throws -> Int8       { try getNextValue { try $0.unwrapFixedWidthInteger() } }
        mutating func decode(_: Int16.Type) throws -> Int16     { try getNextValue { try $0.unwrapFixedWidthInteger() } }
        mutating func decode(_: Int32.Type) throws -> Int32     { try getNextValue { try $0.unwrapFixedWidthInteger() } }
        mutating func decode(_: Int64.Type) throws -> Int64     { try getNextValue { try $0.unwrapFixedWidthInteger() } }
        mutating func decode(_: UInt.Type) throws -> UInt       { try getNextValue { try $0.unwrapFixedWidthInteger() } }
        mutating func decode(_: UInt8.Type) throws -> UInt8     { try getNextValue { try $0.unwrapFixedWidthInteger() } }
        mutating func decode(_: UInt16.Type) throws -> UInt16   { try getNextValue { try $0.unwrapFixedWidthInteger() } }
        mutating func decode(_: UInt32.Type) throws -> UInt32   { try getNextValue { try $0.unwrapFixedWidthInteger() } }
        mutating func decode(_: UInt64.Type) throws -> UInt64   { try getNextValue { try $0.unwrapFixedWidthInteger() } }
        
        mutating func decode<T>(_: T.Type) throws -> T where T: Decodable   { try getNextValue { try $0.unwrap() } }
        
        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
            try getNextValue { try $0.container(keyedBy: type) }
        }
        
        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer   { try getNextValue { try $0.unkeyedContainer() } }
        
        mutating func superDecoder() throws -> Swift.Decoder    { try getNextValue { $0 } }
    }
}

extension DynamicCodableDecoder.Decoder {
    struct SingleValueContainter: SingleValueDecodingContainer {
        let decoder: DynamicCodableDecoder.Decoder
        var codingPath: [CodingKey] { decoder.codingPath }
        
        func decodeNil() -> Bool { decoder.representation == .nil }
        
        func decode(_: Bool.Type) throws -> Bool        { try decoder.unwrap() }
        func decode(_: String.Type) throws -> String    { try decoder.unwrap() }

        func decode(_: Double.Type) throws -> Double    { try decoder.unwrapFloatingPoint() }
        func decode(_: Float.Type) throws -> Float      { try decoder.unwrapFloatingPoint() }

        func decode(_: Int.Type) throws -> Int          { try decoder.unwrapFixedWidthInteger() }
        func decode(_: Int8.Type) throws -> Int8        { try decoder.unwrapFixedWidthInteger() }
        func decode(_: Int16.Type) throws -> Int16      { try decoder.unwrapFixedWidthInteger() }
        func decode(_: Int32.Type) throws -> Int32      { try decoder.unwrapFixedWidthInteger() }
        func decode(_: Int64.Type) throws -> Int64      { try decoder.unwrapFixedWidthInteger() }
        func decode(_: UInt.Type) throws -> UInt        { try decoder.unwrapFixedWidthInteger() }
        func decode(_: UInt8.Type) throws -> UInt8      { try decoder.unwrapFixedWidthInteger() }
        func decode(_: UInt16.Type) throws -> UInt16    { try decoder.unwrapFixedWidthInteger() }
        func decode(_: UInt32.Type) throws -> UInt32    { try decoder.unwrapFixedWidthInteger() }
        func decode(_: UInt64.Type) throws -> UInt64    { try decoder.unwrapFixedWidthInteger() }

        func decode<T>(_: T.Type) throws -> T where T: Decodable    { try decoder.unwrap() }
    }
}
