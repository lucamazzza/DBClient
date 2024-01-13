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
// Created by Luca Mazza on 2024/1/10.

/// This extension provides default values for many of the ``SQLDialect`` properties.
///
/// These default values represent a baseline set of syntax and features that are common ground
/// for as many dialects as possible, so to avoid the rupture of all existing dialects every time
/// a new requirement is due and is added to the protocol.
///
/// This also allows for gradual adaptation of new features.
///
/// - Authors: Luca Mazza
/// - Version: 1.0.0
extension SQLDialect {
    
    public var literalDefault: any SQLExpression { SQLRaw("DEFAULT") }
    
    public var literalStringQuote: any SQLExpression { SQLRaw("'") }
    
    public var supportsIfExists: Bool { true }
    
    public var autoIncrementFunction: (any SQLExpression)? { nil }
    
    public var supportsDropBehavior: Bool { false }
    
    public var supportsReturning: Bool { false }
    
    public var alterTableSyntax: SQLAlterTableSyntax { .init() }
    
    public var triggerSyntax: SQLTriggerSyntax { .init() }
    
    public func customDataType(for dataType: SQLDataType) -> (any SQLExpression)? { nil }
    
    public func normalizeSQLConstraint(identifier: any SQLExpression) -> any SQLExpression { identifier }
    
    public var upsertSyntax: SQLUpsertSyntax { .unsupported }
    
    public var unionFeatures: SQLUnionFeatures { [.union, .unionAll] }
    
    public var sharedSelectLockExpression: (any SQLExpression)? { nil }
    
    public var exclusiveSelectLockExpression: (any SQLExpression)? { nil }
    
    public func nestedSubpathExpression(in column: any SQLExpression, for path: [String]) -> (any SQLExpression)? { nil }
}
