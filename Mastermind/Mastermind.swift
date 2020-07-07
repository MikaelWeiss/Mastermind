//
//  Mastermind.swift
//  Mastermind
//
//  Created by Mikael Weiss on 7/6/20.
//  Copyright © 2020 MikeStudios. All rights reserved.
//

import Foundation

struct MastermindGame<ObjectInEachRow> where ObjectInEachRow: Equatable {
    private let allRows: [OneRow?]
    private(set) var finalRow: OneRow
    private let numberOfRows: Int
    
    init(itemsInFinalRow: [ObjectInEachRow], numberOfRows: Int) {
        allRows = [OneRow?](repeating: OneRow(width: itemsInFinalRow.count), count: numberOfRows)
        finalRow = OneRow(width: itemsInFinalRow.count)
        finalRow.rows = itemsInFinalRow
        self.numberOfRows = numberOfRows
    }
    
    struct OneRow {
        private let rowWidth: Int
        var rows: [ObjectInEachRow?]
        
        init(width: Int) {
            rowWidth = width
            rows =  [ObjectInEachRow?](repeating: nil, count: width)
        }
        
        mutating func changeItemObjectFor(index: Int, to newObject: ObjectInEachRow?) {
            if index > rowWidth { return }
            rows[index] = newObject
        }
    }
}
