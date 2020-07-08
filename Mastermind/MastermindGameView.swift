//
//  MastermindGameView.swift
//  Mastermind
//
//  Created by Mikael Weiss on 7/6/20.
//

import SwiftUI

struct MastermindGameView: View {
    @ObservedObject var viewModel: MastermindGameIntVM
    
    var body: some View {
        ZStack {
            VStack {
                Row(currentRow: viewModel.finalRow, isDark: true).disabled(true)
                Spacer()
            }
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(0..<viewModel.allRows.count, id: \.self) { index in
                        Row(currentRow: viewModel.allRows[index])
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MastermindGameView(viewModel: MastermindGameIntVM(numberOfColumns: 4, numberOfRows: 10, options: [1, 2, 3, 4, 5, 6]))
    }
}
//MARK: - Row Things

struct Row: View {
    @State private var currentSelectionIndex: Int?
    @State private var selected = false
    private var isDark: Bool
    
    init(currentRow: [Int?], isDark: Bool = false) {
        self.isDark = isDark
        self.currentRow = currentRow
    }
    
    var currentRow: [Int?]
    
    var body: some View {
        HStack {
            Grid(compared: [Compared](repeating: .samePosition, count: 4))
            ForEach(0..<currentRow.count, id: \.self) { index in
                Item(selected: selected && currentSelectionIndex == index, isDark: isDark) {
                    Text(currentRow[index] != nil ? "\(currentRow[index]!)" : "")
                }
                .padding()
                .onTapGesture {
                    if currentSelectionIndex == index {
                        selected = false
                    } else {
                        selected = true
                    }
                    currentSelectionIndex = index
                }
            }
        }
    }
}

struct Item<Content: View>: View {
    private let isDark: Bool
    let selected: Bool
    let content: Content
    
    init(selected: Bool, isDark: Bool = false, @ViewBuilder content: () -> Content) {
        self.isDark = isDark
        self.selected = selected
        self.content = content()
    }
    
    var body: some View {
        Image(systemName: isDark ? "circle.fill" : "circle")
            .overlay(
                content
            )
            .font(.system(size: 30, weight: selected ? .bold : .medium))
    }
}

//MARK: - Comparison Things

struct Grid: View {
    var compared: [Compared?] = [nil, nil, nil, nil] {
        didSet(oldComparisons) {
            if oldComparisons.count != compared.count {
                compared = oldComparisons
            }
        }
    }
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Comparison(compared: compared[0])
                Comparison(compared: compared[1])
            }
            HStack {
                Comparison(compared: compared[2])
                Comparison(compared: compared[3])
            }
        }
    }
}


struct Comparison: View {
    var compared: Compared?
    
    var body: some View {
        Image(systemName:
                compared == Compared.samePosition ? "star.fill" :
                compared == Compared.inScopeButNotSamePosition ? "circle.fill" :
                "circle"
        )
    }
}
