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

/// Abstract definition of a specific dialect of SQL. I use an ``SQLDatabase``
/// dialect to control different aspects of the query serialization process.
///
/// The use of this protocol is intended to keep the user-facing API from
/// having to expose DB-specific details as much as possible.
///
/// While the SQL dialects are too many and too varied for this protocol to be
/// as effective as I wanted, but it is practically better than having to
/// implement new drivers for each different database version/kind.
///
/// - Authors: Luca Mazza
/// - Version: 1.0.0
public protocol SQLDialect {

    /// The name given to the dialect.
    ///
    /// Dialect names are intended to be human-readable strings, but they are also
    /// used as identifiers throughout the codebase.
    /// That said, dialect names are required to be unique (globally), even if there
    /// is no way to enforce this with the current implementation.
    ///
    /// I recommend to follow the form descripted as follows:
    /// - start with a lowercase letter;
    /// - continue with lowercase letter, digits and/or dashes.
    ///
    /// - Note: No default value is provided.
    var name: String { get }

    /// Defines the quote identifier of the dialect.
    ///
    /// Quote identifiers, usually provided as ``SQLRaw`` are the characters used to
    /// define tables and columns names, and are placed immediately before and after
    /// each identifier. For example the identifier is the accent symbol (`).
    ///
    /// - Note: No default value is provided.
    var identifierQuote: any SQLExpression { get }

    /// Defines the quote used on strings of the dialect.
    ///
    /// Every string that appears in a query, such as enum names and string literals
    /// are surrounded by the string quote.
    ///
    /// - Note: The default value is an apostrophe (`'`).
    var literalStringQuote: any SQLExpression { get }

    /// Defines if the dialect supports auto increment.
    ///
    /// Auto-Increment is a feature builtin in most SQL databases that increments
    /// automatically, when possible, the primary key as we insert new rows.
    ///
    /// See also ``autoIncrementClause`` and ``autoIncrementFunction-9i6e7``.
    ///
    /// This field is `true` if the dialect supports such feature, `false` otherwise.
    ///
    /// - Note: No default value is provided.
    var supportsAutoIncrement: Bool { get }

    /// Defines the auto increment clause of the dialect.
    ///
    /// When we specify a constraint on a primary key, an expression is inserted into
    /// the column. This clause is included right after the `PRIMARY KEY` in the SQL
    /// syntax.
    ///
    /// This property is ignored if the dialect does not support automatic incrementation,
    /// so when ``supportsAutoIncrement`` is `false` or ``autoIncrementFunction-9i6e7`` is `nil`
    ///
    /// - Note: No default value is provided.
    var autoIncrementClause: any SQLExpression { get }

    /// Defines the auto increment function of the dialect.
    ///
    /// When we specify a constraint on a primary key, an expression is inserted into
    /// the column. The expression is preceded by the ``literalDefault-5sspz`` expression
    /// and will appear right before the `PRIMARY KEY` in the SQL.
    ///
    /// This property is ignored when ``supportsAutoIncrement`` is `false` and, if this property
    /// is not `nil`, it has precedence over ``autoIncrementClause``.
    ///
    /// - Note: The default value is `nil`.
    var autoIncrementFunction: (any SQLExpression)? { get }

    /// Defines the literal default expression of the dialect.
    ///
    /// In SQL, to express the behaviours "use this as default value", in a column definition and
    /// "use the default value for this column" are serialized to this expression.
    ///
    /// - Note: Default value is `SQLRaw("DEFAULT")`.
    var literalDefault: any SQLExpression { get }

    /// Defines whether or not the dialect supports the `IF EXISTS` modifier and the `IF NOT EXISTS`.
    ///
    /// This field is set to `true` when the dialect supports the use of this modifiers on all types
    /// of `DROP` queries, such as ``SQLDropEnum``, ``SQLDropIndex``, ``SQLDropTable`` and
    /// ``SQLDropTrigger``, and for `SQLCreateTable` queries. It is not possible for now to
    /// check if the dialect supports only one of the two.
    ///
    /// - Note: Default value is `true`.
    var supportsIfExists: Bool { get }

    /// Defines the syntax supported by the dialect, for strongly-typed enums.
    ///
    /// See ``SQLEnumSyntax`` for possible values.
    ///
    /// - Note: No default value is provided.
    var enumSyntax: SQLEnumSyntax { get }

    /// Defines whether or not the dialect supports the ``SQLDropBehavior``modifier.
    ///
    /// When this field is `true`, the ``SQLDropBehavior`` modifier is supported.
    /// This kind of behaviour is supported on `DROP` queries.
    ///
    /// - Note: No default value is provided.
    var supportsDropBehaviour: Bool { get }

    /// Defines whether or not the dialect supports returning clauses.
    ///
    /// The field is set to `true` when the dialect supports the use of the `RETURNING` clause
    /// for retrieving output values from DML queries (`INSERT`, `UPDATE`, `DELETE`).
    ///
    /// See ``SQLReturning`` and ``SQLReturningBuilder`` for more.
    ///
    /// - Note: Default value is `false`.
    var supportsReturning: Bool { get }

    /// Defines the syntax supported by the dialect.
    ///
    /// These are composed of various flags that describe the support of various specific features
    /// of `CREATE/DROP TRIGGER` queries.
    ///
    /// See ``SQLTriggerSyntax`` for more.
    ///
    /// - Note: Defaults to an expression which defines no supported features.
    var triggerSyntax: SQLTriggerSyntax { get }

    /// Defines the syntax to alter a table's definition support by the dialect.
    ///
    /// See ``SQLAlterTableSyntax`` for more.
    ///
    /// - Note: Defaults to an expression which defines no supported features.
    var alterTableSyntax: SQLAlterTableSyntax { get }

    /// Defines the type of `UPSERT` syntax supported by the dialect.
    ///
    /// See ``SQLUpsertSyntax`` for more.
    ///
    /// - Note: Defaults to `.unsupported`.
    var upsertSyntax: SQLUpsertSyntax { get }

    /// Defines the union features supported by the dialect.
    ///
    /// It is a set of flags describing the dialect's support for different forms of `UNION` with
    /// `SELECT` queries.
    ///
    /// See ``SQLUnionFeatures`` for more information and possible flags.
    /// Defaults to `[.union, .unionAll]`.
    var unionFeatures: SQLUnionFeatures { get }

    /// Defines the lock expression supported by the dialect.
    ///
    /// This is a serialization for ``SQLLockingClause/share``, that represents the request of
    /// a shared read lock on rows, when these are retrieved by a `SELECT`.
    /// query.
    ///
    /// A `nil` value intends that the database does not support exclusive locking requests and
    /// causes this clause to be ignored.
    ///
    /// - Note: Defaults to `nil`.
    var sharedSelectLockExpression: (any SQLExpression)? { get }

    /// Defines the lock expression supported by the dialect.
    ///
    /// This is a serialization for ``SQLLockingClause/update``, that represents the request of
    /// an exclusive write lock on rows, when these are retrieved by a `SELECT`.
    /// query.
    ///
    /// A `nil` value intends that the database does not support exclusive locking requests and
    /// causes this clause to be ignored.
    ///
    /// - Note: Defaults to `nil`.    var exclusiveSelectLockExpression: (any SQLExpression)? { get }
    var exclusiveSelectLockExpression: (any SQLExpression)? { get }


    /// Returns an expression that can be used as placeholder for a bound parameter in a query.
    /// The function ignores the value of the bound if the syntax does not require it.
    ///
    /// - Parameters:
    ///    - position: Defines which bound parameter to create a placeholder for, of which the first
    ///         parameter has position `1` (1-based). This value is guaranteed to be `> 0`.
    ///
    /// - Returns: An expression that can be used as placeholder for a bound parameter in a query.
    ///
    /// - Note: No default implementation provided.
    func bindPlaceholder(at index: Int) -> any SQLExpression

    /// Returns an SQLExpression, usually an `SQLRaw`, representing a given boolean literal.
    /// Practically, it converts a `Bool` value to an `SQLExpression`.
    ///
    /// - Parameters:
    ///    - value: The boolean value to convert
    ///
    /// - Returns: An SQLExpression representing the given boolean value
    ///
    /// - Note: No default implementation provided.
    func literalBoolean(_ value: Bool) -> any SQLExpression

    /// Function to be called when serializing ``SQLDataType``s into queries.
    /// Returns an expression which replaces the default serialization of the given type.
    ///
    /// Returning `nil` causes the default serialization to be used. This functionality is intended to
    /// provide customizability for dialects, allowing to override or extend the default set of types and
    /// their default definitions.
    ///
    /// - Parameters:
    ///    - dataType: The ``SQLDataType`` to customize
    ///
    /// - Returns: An expression which replaces the default serialization of the given type
    ///
    /// - Note: By default returns `nil` for all inputs.
    func customDataType(for dataType: SQLDataType) -> (any SQLExpression)?

    /// Function to be called when constraints names are serialized into a query
    /// The dialect returns an expression for a unique identifier (to the input) that is a valid constraint
    /// name in the context of the dialect.
    ///
    /// Provides an interception point for dialects which apply limitations on constraint names, like length
    /// limits or db-wide uniqueness.
    ///
    /// The reverse-conversion of a normalized identifier into its original form is not a requirement
    /// for the conformity of the dialect, as the conversion may be lossy and we don't care about it.
    ///
    /// Conformity requires the following:
    /// - When given the same input, output must always be the same;
    /// - Different input must always result in a unique output.
    /// An hashing algorithm with a sufficiently large output is one correct implementation (i.e. SHA256).
    ///
    /// - Parameters:
    ///    - identifier: The identifier to normalize
    ///
    /// - Returns: The normalized identifier
    ///
    /// - Note: By default returns the input identifier, without any variation.
    func normalizeSQLConstraint(identifier: any SQLExpression) -> any SQLExpression

    /// Function that, given a column name and a path with multiple elements inside, as it would be a
    /// JSON-Structure, returns the appropriate expression to access the value at the given JSON path.
    ///
    /// - Parameters:
    ///    - column: The column name, on which the path is based
    ///    - path: The JSON path
    ///
    /// - Returns: The expression to access the value at the given JSON path
    ///
    /// - Note: By default returns `nil`
    func nestedSubpathExpression(in column: any SQLExpression, for path: [String]) -> (any SQLExpression)?

}
