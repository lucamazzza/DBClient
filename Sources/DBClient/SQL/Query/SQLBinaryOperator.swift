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

public enum SQLBinaryOperator: SQLExpression {

    /// `=` or `==`
    case eq

    /// `<>` or `!=`
    case ne

    /// `>`
    case gt

    /// `>=`
    case lt

    /// `<=`
    case gte

    /// `<`
    case lte

    /// `LIKE`
    case lk

    /// `NOT LIKE`
    case nl

    /// `IN`
    case `in`

    /// `NOT IN`
    case ni

    /// `AND`
    case and

    /// `OR`
    case or

    /// `||`
    case concat

    /// `*`
    case mult

    /// `/`
    case div

    /// `%`
    case mod

    /// `+`
    case add

    /// `-`
    case subtr

    /// `IS`
    case `is`

    /// `IS NOT`
    case isnot

    @inlinable
    public func serialize(to serializer: inout SQLSerializer) {
        switch self {
            case .eq: serializer.write("=")
            case .ne: serializer.write("<>")
            case .gt: serializer.write(">")
            case .gte: serializer.write(">=")
            case .lt: serializer.write("<")
            case .lte: serializer.write("<=")
            case .and: serializer.write("AND")
            case .or: serializer.write("OR")
            case .in: serializer.write("IN")
            case .ni: serializer.write("NOT IN")
            case .is: serializer.write("IS")
            case .isnot: serializer.write("IS NOT")
            case .lk: serializer.write("LIKE")
            case .nl: serializer.write("NOT LIKE")
            case .mult: serializer.write("*")
            case .div: serializer.write("/")
            case .mod: serializer.write("%")
            case .add: serializer.write("+")
            case .subtr: serializer.write("-")
            case .concat:
                // See https://dev.mysql.com/doc/refman/8.0/en/concat.html
                fatalError("""
                    || not implemented, as MySQL does't always support it, even if anyone else does.
                    Use `SQLFunction("CONCAT", args...)` for MySQL or `SQLRaw("||")` with Postgre and SQLite.
                """)

        }
    }
}
