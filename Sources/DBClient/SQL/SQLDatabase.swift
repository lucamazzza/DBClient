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

import NIOCore
import Logging

/// This is the core of the library. It is a common interface is the access point
/// of the generic `SQL` part of the package for all the SQL-Type database clients.
///
/// Conformance to the ``SQLDatabase`` protocol allows the database client to
/// use the `SQL` functionnalities, for SQL-Type database clients.
///
/// A SQL-Based driver package must provide a concrete implementation of the
/// ``SQLDatabase`` protocol.
///
/// - Note: Please see ``SQLQueryBuilder`` for when you need an Higher-Level API
///     Access to a database, as ``SQLDatabase`` stays at a lower-than adviced level.
///
/// ```swift
/// var expr = SQLSelect()
/// expr.columns = [SQLColumn(SQLIdentifier("id"))]
/// expr.tables = [SQLColumn(SQLIdentifier("users"))]
/// expr.predicate = SQLBinaryExpression(
///     left: SQLColumn(SQLIdentifier("id")),
///     operator: SQLBinaryOperator.equal,
///     right: SQLValue(102)
/// )
/// // Query: SELECT id FROM users WHERE id = 102
/// var rows: [SQLRow] = []
/// let db = // <getDB>
///
/// try await db.execute(sql: expr, onRow: rows.append(_:))
/// ```
///
/// - Authors: Luca Mazza
/// - Version: 1.0.0
public protocol SQLDatabase {

    /// ``Logger`` used to keep track of all executed queries and operations.
    var logger: Logger { get }

    /// Imported from ``NIOCore``.
    /// It is used to execute asynchronous operations on a database.
    ///
    /// If there is no ``EventLoop`` available it's recommended to return
    /// any event loop ``NIOCore/EventLoopGroup/any()``.
    ///
    /// That case indicates, for example, the connection to a pool which assigns
    /// loops to each connection at point of use. Another example is when the
    /// asynchronous operations are managed by Swift Concurrency or any other.
    var eventLoop: any EventLoop { get }

    /// Version the connection reports itsself to.
    /// It's provided as type conforming to ``SQLDatabaseReportedVersion``.
    /// When the version is not applicable or yet unknown, it is `nil`
    /// This case can happen, for example, when using a connection
    /// pool dispach wrapper.
    ///
    /// - Warning: the version a database reports has nothing to do
    ///     with anything implemented in `BSQL`, nor does it represent any values
    ///     stored in the database. It is the version that the the database presents
    ///     itsself when connecting. This field is implemented to customize the dialect
    ///     on the features currently available on the database given its version
    ///     rather then implementing a safe-but-limited solution with the features common
    ///     to all the versions.
    var version: SQLDatabaseReportedVersion? { get }

    /// Descriptor for the database's supported SQL-Dialect.
    /// It's allowed for different connection to the same database to have different
    /// dialects, even though i doubt this is very useful.
    var dialect: SQLDialect { get }

    /// The log level used to report queries ran on the given database.
    /// It's default value is ``Logging/Logger/Level/debug``.
    ///
    /// This log applies only on the serialized SQL text and bound parameters of the queries.
    /// It doesn't affect any logging by any underlying logger.
    ///
    /// When the value is `nil`, it means that logging is disabled.
    ///
    /// - Important: Conforming driver must have a mean to configure this value and use
    ///     its default  ``Logging/Logger/Level/debug`` level if no explicit value is provided.
    ///     It's also up to it to perform the query logging, inclusive the respect of the level.
    var queryLogLevel: Logger.Level? { get }

    /// Execute a SQL query on the database.
    /// Requests the execution of a given generic SQL Query after its serialization.
    /// Invokes the closure ``onRow`` for each row returned.
    func execute(
        sql query: any SQLExpression,
        _ onRow: @escaping (any SQLRow) -> ()
    ) -> EventLoopFuture<Void>
}
