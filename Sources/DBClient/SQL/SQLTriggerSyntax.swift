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

/// Structure that controls the syntatcic behaviour of the queries:
/// - `CREATE TRIGGER...`;
/// - `DROP TRIGGER...`.
///
/// Defines two inner structures that manage the behaviour of the `CREATE` query and
/// the `DROP` query.
///
/// - Authors: Luca Mazza
/// - Version 1.0.0
public struct SQLTriggerSyntax {

    /// Inner structure to manage the states of the `CREATE` query
    /// Defines different options when creating such query.
    public struct Create: OptionSet {

        /// Represents the integer value associated with the different types of
        /// `CREATE TRIGGER` queries.
        ///
        /// Here's a quick rundown of the binary values and their meaning:
        /// - `---------1`: Requires `FOR EACH ROW`
        /// - `--------1-`: Support for trigger body
        /// - `-------1--`: Supports conditions
        /// - `------1---`: Supports definer
        /// - `-----1----`: Supports foreach
        /// - `----1-----`: Supports order
        /// - `---1------`: Supports update
        /// - `--1-------`: Supports constraints
        /// - `-1--------`: Requires PostgreSQL checks
        /// - `1---------`: Conditions require parentheses
        public var rawValue = 0

        /// Initializes a new ``Create`` structure with the given ``rawValue``
        public init(rawValue: Int) {self.rawValue = rawValue}

        /// Represents the requirement for a `FOR EACH ROW` clause,
        /// by then shifting in ``rawValue`` the value 1, 0 times.
        public static var requiresForEachRow: Self { .init(rawValue: 1 << 0) }

        /// Represents the clause which defines whether or not the trigger can have a body,
        /// by then shifting in ``rawValue`` the value 1, 1 time.
        public static var supportsBody: Self { .init(rawValue: 1 << 1) }

        /// Represents the clause which defines whether or not trigger can contain conditions,
        /// by then shifting in ``rawValue`` the value 1, 2 times.
        public static var supportsCondition: Self { .init(rawValue: 1 << 2) }

        /// Represents the clause which defines whether or not trigger supports a definer,
        /// by then shifting in ``rawValue`` the value 1, 3 times.
        public static var supportsDefiner: Self{ .init(rawValue: 1 << 3) }

        /// Represents the clause which defines whether or not trigger supports a definer,
        /// by then shifting in ``rawValue`` the value 1, 4 times.
        public static var supportsForEach: Self{ .init(rawValue: 1 << 4) }

        /// Represents the clause which defines whether or not trigger supports ordering,
        /// by then shifting in ``rawValue`` the value 1, 5 times.
        public static var supportsOrder: Self { .init(rawValue: 1 << 5) }

        /// Represents the clause which defines whether or not trigger supports the `UPDATE`
        /// clause on columns, by then shifting in ``rawValue`` the value 1, 6 times.
        public static var supportsUpdateColumns: Self { .init(rawValue: 1 << 6) }

        /// Represents the clause which defines whether or not trigger supports constraints,
        /// by then shifting in ``rawValue`` the value 1, 7 times.
        public static var supportsConstraints: Self { .init(rawValue: 1 << 7) }

        /// Represents the clause which defines whether or not trigger needs to run postgreSQL
        /// checks, by then shifting in ``rawValue`` the value 1, 8 times.
        public static var postgreSQLChecks: Self { .init(rawValue: 1 << 8) }

        /// Represents the clause which defines whether or not trigger's conditions require
        /// parentheses, by then shifting in ``rawValue`` the value 1, 9 times.
        public static var conditionRequiresParentheses: Self { .init(rawValue: 1 << 9) }
    }

    /// Inner structure to manage the states of the `DROP` query
    /// Defines different options when creating such query.
    public struct Drop: OptionSet {

        /// Represents the integer value associated with the different types of
        /// `DROP TRIGGER` queries.
        ///
        /// Here's a quick rundown of the binary values and their meaning:
        /// - `---------1`: Supports tables' name
        /// - `--------1-`: Supports cascading
        public var rawValue = 0

        /// Initializes a new ``Drop`` structure with the given ``rawValue``
        public init(rawValue: Int) {self.rawValue = rawValue}

        /// Represents the clause which defines whether or not the trigger supports
        /// table names on drop, by then shifting in ``rawValue`` the value 1, 0 times.
        public static var supportsTableName: Self { .init(rawValue: 1 << 0) }

        /// Represents the clause which defines whether or not the trigger supports
        /// cascading on drop, by then shifting in ``rawValue`` the value 1, 1 times.
        public static var supportsCascade: Self { .init(rawValue: 1 << 1) }
    }

    /// ``Create`` instance for the structure ``SQLTriggerSyntax``.
    public var create: Create

    /// ``Drop`` instance for the structure ``SQLTriggerSyntax``.
    public var drop: Drop

    /// Initializes the ``SQLTriggerSyntax`` instance.
    ///
    /// - Parameters:
    ///    - create: ``Create`` instance
    ///    - drop : ``Drop`` instance
    public init(create: Create = [], drop: Drop = []) {
        self.create = create
        self.drop = drop
    }
}
