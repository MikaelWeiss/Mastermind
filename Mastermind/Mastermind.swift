//
//  Mastermind.swift
//  Mastermind
//
//  Created by Mikael Weiss on 7/6/20.
//  Copyright © 2020 MikeStudios. All rights reserved.
//

import Foundation

struct MastermindGame<ObjectInEachRow> where ObjectInEachRow: Equatable {
    private(set) var allRows: [OneRow]
    private(set) var finalRow: OneRow {
        didSet(oldRow) {
            if oldRow.items.count != finalRow.items.count {
                finalRow = oldRow
            }
        }
    }
    let numberOfColumns: Int
    let numberOfRows: Int
    
    init(columns: Int, rows: Int) {
        allRows = [OneRow](repeating: OneRow(columns: columns), count: rows)
        finalRow = OneRow(columns: columns)
        numberOfColumns = columns
        numberOfRows = rows
    }
    
    mutating func changeItemObjectFor(row: Int, column: Int, newItem: ObjectInEachRow?) {
        if row > allRows.count - 1 || column > numberOfColumns - 1 { return }
        allRows[row].changeItemObjectFor(index: column, to: newItem)
    }
    
    func compareIfFinalRowIsEqualToRow(at row: Int) -> [Compared]? {
        if row > allRows.count - 1 || row < allRows.count - 1 { return nil }
        var temp = [Compared]()
        for index in 0..<numberOfColumns {
            if allRows[row].items[index] == finalRow.items[index] {
                temp.append(Compared.samePosition)
            } else {
                if finalRow.items.contains(allRows[row].items[index]) {
                    temp.append(Compared.inScopeButNotSamePosition)
                }
            }
        }
        if temp.count < 1 { return nil }
        return temp
    }
    
    mutating func setFinalRowFor(items: [ObjectInEachRow]) {
        if items.count != numberOfColumns { return }
        finalRow.items = items
    }
    
    struct OneRow {
        private let columns: Int
        var items: [ObjectInEachRow?]
        
        init(columns: Int) {
            self.columns = columns
            items = [ObjectInEachRow?](repeating: nil, count: columns)
        }
        
        mutating func changeItemObjectFor(index: Int, to newObject: ObjectInEachRow?) {
            if index > columns - 1 { return }
            items[index] = newObject
        }
    }
}
