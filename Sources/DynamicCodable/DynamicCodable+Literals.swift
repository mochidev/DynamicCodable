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


extension DynamicCodable.Key: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}
}
