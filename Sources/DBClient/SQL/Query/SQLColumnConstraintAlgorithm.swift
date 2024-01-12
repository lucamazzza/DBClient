// MIT License
//
// Copyright (c) 2024 Luca Mazza
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// Created by Luca Mazza on 2024/1/11.

public enum SQLColumnConstraintAlgorithm: SQLExpression {

    case primaryKey(autoIncrement: Bool)

    case notNull

    case unique

    case check(any SQLExpression)

    case collate(name: any SQLExpression)

    case `default`(reference: any SQLExpression)

    case foreignKey(references: any SQLExpression)

    case generated(any SQLExpression)

    case custom(any SQLExpression)

    @inlinable
    public static var primaryKey: SQLColumnConstraintAlgorithm {
        .primaryKey(autoIncrement: true)
    }

    @inlinable
    public static func collate(name: String) -> SQLColumnConstraintAlgorithm {
        .collate(name: SQLIdentifier(name))
    }

    @inlinable
    public static func `default`(_ val: String) -> SQLColumnConstraintAlgorithm {
        .default(SQLLiteral.string(val))
    }

    @inlinable
    public static func `default`<T: BinaryInteger>(_ val: T) -> SQLColumnConstraintAlgorithm {
        .default(SQLLiteral.numeric("\(val)"))
    }

    @inlinable
    public static func `default` <T: FloatingPoint>(_ val: T) -> SQLColumnConstraintAlgorithm {
        .default(SQLLiteral.numeric("\(val)"))
    }

    @inlinable
    public static func `default`(_ val: Bool) -> SQLColumnConstraintAlgorithm {
        .default(SQLLiteral.boolean(val))
    }
}
