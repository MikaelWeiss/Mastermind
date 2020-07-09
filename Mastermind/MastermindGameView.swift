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
        VStack {
            Row(currentRow: viewModel.finalRow, isDark: true).disabled(true)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(0..<viewModel.allRows.count, id: \.self) { index in
                        Row(currentRow: viewModel.allRows[index])
                    }
                }
            }
            HStack {
                CircleButton() { }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    SelectionBar(items: viewModel.options)
                }
                
                CircleButton() { }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MastermindGameView(viewModel: MastermindGameIntVM(numberOfColumns: 4, numberOfRows: 10, options: [1, 2, 3, 4, 5, 6]))
    }
}

//MARK: - Buttons

struct CircleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Circle()
                .frame(width: 44, height: 44)
        }
    }
}

//MARK: - Selection Things

struct SelectionBar: View {
    let items: [Int]
    @State private var selectedItem: Int?
    @State private var selected: Bool?
    var currentItem: Int? {
        selectedItem
    }
    
    init(items: [Int]) {
        self.items = items
        selectedItem = items.first
    }
    
    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                Item(selected: selectedItem == item && selected ?? false) {
                    Text("\(item)")
                }
                .onTapGesture {
                    if selectedItem == item {
                        selected = false
                        selectedItem = nil
                    } else {
                        selected = true
                        selectedItem = item
                    }
                }
            }
        }
    }
}


//MARK: - Row Things

struct Row: View {
    @State private var currentSelectionIndex: Int?
    @State private var selected: Bool?
    private var isDark: Bool
    private let actionOnTap: () -> Void
    
    init(currentRow: [Int?], isDark: Bool = false, actionOnTap: @escaping () -> Void) {
        self.isDark = isDark
        self.currentRow = currentRow
        self.actionOnTap = actionOnTap
    }
    
    var currentRow: [Int?]
    
    var body: some View {
        HStack {
            Grid(compared: [Compared](repeating: .samePosition, count: 4))
            ForEach(0..<currentRow.count, id: \.self) { index in
                Item(selected: selected ?? false && currentSelectionIndex == index, isDark: isDark) {
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
                    actionOnTap()
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
            .font(.system(size: fontSize, weight: selected ? .bold : .medium))
    }
    
    //MARK: Item Drawing Constants
    private let fontSize: CGFloat = 30
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
