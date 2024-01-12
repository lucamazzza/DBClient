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

public struct SQLAlterColumnDefinitionType: SQLExpression {

    public var col: any SQLExpression

    public var dataType: any SQLExpression

    @inlinable
    public init(col: any SQLExpression, dataType: any SQLExpression) {
        self.col = col
        self.dataType = dataType
    }

    @inlinable
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.statement {
            $0.append(self.col)
            if let clause = $0.dialect.alterTableSyntax.alterColumnDefinitionTypeKeyword {
                $0.append(clause)
            }
            $0.append(self.dataType)
        }
    }
}
