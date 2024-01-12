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

public struct SQLAlterTable: SQLExpression {

    public var name: any SQLExpression

    public var newName: (any SQLExpression)?

    public var addCols: [any SQLExpression]

    public var modifyCols: [any SQLExpression]

    public var dropCols: [any SQLExpression]

    public var addTableConstraints: [any SQLExpression]

    public var dropTableConstraints: [any SQLExpression]

    @inlinable
    public init(name: any SQLExpression) {
        self.name = name
        self.newName = nil
        self.addCols = []
        self.modifyCols = []
        self.dropCols = []
        self.addTableConstraints = []
        self.dropTableConstraints = []
    }

    public func serialize(to serializer: inout SQLSerializer) {
        let syntax = serializer.dialect.alterTableSyntax
        if !syntax.allowsBatch && self.addCols.count + self.modifyCols.count + self.dropCols.count > 1 {
            serializer.database.logger.warning("Database does not support batch table alterations. You will need to rewrite as individual alter statements.")
        }
        if syntax.alterColumnDefinitionClause == nil && self.modifyCols.count > 0 {
            serializer.database.logger.warning("Database does not support column modifications. You will need to rewrite as drop and add clauses")
        }
        let additions = (self.addCols + self.addTableConstraints).map { col in
            (verb: SQLRaw("ADD"), definition: col)
        }
        let removals = (self.dropCols + self.dropTableConstraints).map { col in
            (verb: SQLRaw("DROP"), definition: col)
        }
        let alterColumnDefinitionClause = syntax.alterColumnDefinitionClause ?? SQLRaw("Modify")
        let modifications = self.modifyCols.map { col in
            (verb: alterColumnDefinitionClause, definition: col)
        }
        let alterations = additions + removals + modifications
        serializer.statement {
            $0.append("ALTER TABLE")
            $0.append(self.name)
            if let newName = newName {
                $0.append("RENAME TO")
                $0.append(newName)
            }
            for (i, alteration) in alterations.enumerated() {
                if i > 0 {
                    $0.append(",")
                }
                $0.append(alteration.verb)
                $0.append(alteration.definition)
            }
        }
    }
}
