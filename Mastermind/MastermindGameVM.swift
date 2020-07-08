//
//  MastermindGameVM.swift
//  Mastermind
//
//  Created by Mikael Weiss on 7/7/20.
//

import Foundation

class MastermindGameIntVM: ObservableObject {
    typealias gameType = Int
    typealias modelType = MastermindGame<gameType>
    @Published private var model: modelType
    let options: [gameType]
    
    init(numberOfColumns: Int, numberOfRows: Int, options: [gameType]) {
        model = MastermindGameIntVM.createMastermindGame(rows: numberOfRows, columns: numberOfColumns)
        self.options = options
    }
    
    private static func createMastermindGame(rows: Int, columns: Int) -> modelType {
        return modelType(columns: columns, rows: rows)
    }
    
    //MARK: - Access to the model
    
    var finalRow: [gameType?] {
        model.finalRow.items.map { $0 }
    }
    
    var allRows: [[gameType?]] {
        model.allRows.map { $0.items.map { $0 } }
    }
    
    //MARK: - Intents
    
    func changeItemObjectFor(row: Int, column: Int, newItem: gameType) {
        objectWillChange.send()
        model.changeItemObjectFor(row: row, column: column, newItem: newItem)
    }
    
    func setFinalRow(items: [gameType]) {
        objectWillChange.send()
        model.setFinalRowFor(items: items)
    }
    
    func compareIfFinalRowIsEqualToRow(at row: Int) -> [Compared]? {
        model.compareIfFinalRowIsEqualToRow(at: row)
    }
    
    func resetGame() {
        objectWillChange.send()
        let temp = model
        model = MastermindGameIntVM.createMastermindGame(rows: temp.numberOfRows, columns: temp.numberOfColumns)
    }
    
}
