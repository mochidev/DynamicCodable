//
//  DynamicCodable+Literals.swift
//  DynamicCodable
//
//  Created by Dimitri Bouniol on 4/17/21.
//  Copyright © 2021 Mochi Development, Inc. All rights reserved.
//

extension DynamicCodable: ExpressibleByNilLiteral {
    @inlinable
    public init(nilLiteral: ()) {
        self = .nil
    }
}

extension DynamicCodable: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension DynamicCodable: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Double) {
        self = .float64(value)
    }
}

extension DynamicCodable: ExpressibleByBooleanLiteral {
    @inlinable
    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

extension DynamicCodable: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
    @inlinable
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}


extension DynamicCodable.Key: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension DynamicCodable.Key: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
    @inlinable
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}
