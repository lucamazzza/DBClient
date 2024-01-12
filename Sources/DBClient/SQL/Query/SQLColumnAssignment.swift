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

public struct SQLColumnAssignment: SQLExpression {

    public var colName: any SQLExpression

    public var val: any SQLExpression

    @inlinable
    public init(setting colName: any SQLExpression, to val: any SQLExpression) {
        self.colName = colName
        self.val = val
    }

    @inlinable
    public init(setting colName: any SQLExpression, to val: any Encodable) {
        self.init(setting: colName, to: SQLBind(val))
    }

    @inlinable
    public init (setting colName: String, to val: any Encodable) {
        self.init(setting: colName, to: SQLBind(val))
    }

    @inlinable
    public init(setting colName: String, to val: any SQLExpression) {
        self.init(setting: SQLColumn(colName), to: val)
    }

    @inlinable
    public init(settingExcludedValueFor colName: any SQLExpression) {
        self.init(setting: colName, to: SQLExcludedColumn(colName))
    }

    @inlinable
    public init(settingExcludedValueFor colName: String) {
        self.init(settingExcludedValueFor: SQLExcludedColumn(colName))
    }

    @inlinable
    public func serialize(to serializer: inout SQLSerializer){
        serializer.statement {
            $0.append(self.colName)
            $0.append("=")
            $0.append(self.val)
        }
    }
}
