//
//  MastermindGameView.swift
//  Mastermind
//
//  Created by Mikael Weiss on 7/6/20.
//

import SwiftUI

//Switch to something more similar to the "calendar view"
//Ie. rebuild view.

struct MastermindGameView: View {
    @ObservedObject var viewModel: MastermindGameIntVM
    private let selectionBar: SelectionBar
    private var selectionOptions: [[Bool]]
    @State private var selectedItem: Int?
    private var selectedItemRetreval: Int? {
        selectedItem
    }
    
    init(viewModel: MastermindGameIntVM) {
        self.viewModel = viewModel
        selectionBar = SelectionBar(items: viewModel.options)
        selectionOptions = [[Bool]](repeating: [Bool](repeating: false, count: viewModel.finalRow.count), count: viewModel.allRows.count)
    }
    
    var body: some View {
        VStack {
            Row(currentRow: viewModel.finalRow, isDark: true, actionOnTap: { return nil }).disabled(true)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(0..<viewModel.allRows.count, id: \.self) { index in
                        Row(currentRow: self.viewModel.allRows[index], actionOnTap: { return self.selectedItem })
                    }
                }
            }
            HStack {
                CircleButton() { }
                
                GeometryReader { geo in
                    ScrollView(.horizontal, showsIndicators: false) {
                        self.selectionBar
                            .if(CGFloat(self.viewModel.options.count * 35) < geo.size.width) {
                                $0.frame(width: geo.size.width)
                            }
                        .frame(height: geo.size.height)
                        .onTapGesture {
                            self.selectedItem = self.selectionBar.currentItem
                        }
                    }
                }
                .frame(height: 50)
                
                CircleButton() { }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MastermindGameView(viewModel: MastermindGameIntVM(numberOfColumns: 4, numberOfRows: 10, options: [1, 2, 3, 4, 5, 6,7,8,9]))
        }
    }
}

//MARK: - Buttons

struct CircleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
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
        HStack(spacing: itemSpacing) {
            ForEach(items, id: \.self) { item in
                Item(selected: self.selectedItem == item && self.selected ?? false) {
                    Text("\(item)")
                }
                .onTapGesture {
                    if self.selectedItem == item {
                        self.selected = false
                        self.selectedItem = nil
                    } else {
                        self.selected = true
                        self.selectedItem = item
                    }
                }
            }
        }
    }
    //MARK: SelectionBar Drawing Constants
    private let itemSpacing: CGFloat = 5
}


//MARK: - Row Things

struct Row: View {
    @State private var currentSelectionIndex: Int?
    @State private var selected: Bool?
    private var isDark: Bool
    private let actionOnTap: () -> Int?
    private var currentRow: [Int?]
    
    init(currentRow: [Int?], isDark: Bool = false, actionOnTap: @escaping () -> Int?) {
        self.isDark = isDark
        self.currentRow = currentRow
        self.actionOnTap = actionOnTap
    }
    
    var body: some View {
        HStack {
            Grid(compared: [Compared](repeating: .samePosition, count: 4))
            ForEach(0..<currentRow.count, id: \.self) { index in
                Item(selected: self.selected ?? false && self.currentSelectionIndex == index, isDark: self.isDark) {
                    Text(self.currentRow[index] != nil ? "\(self.currentRow[index]!)" : "")
                }
                .padding()
                .onTapGesture {
                    if self.currentSelectionIndex == index {
                        self.selected = false
                    } else {
                        self.selected = true
                    }
                    self.currentSelectionIndex = index
//                    self.setItem(self.actionOnTap(), for: index)
                }
            }
        }
    }
    
    private mutating func setItem(_ item: Int?, for index: Int) {
        self.currentRow[index] = item
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
                    .font(.system(size: contentFontSize, weight: selected ? .bold : .medium, design: .rounded))
            )
            .font(.system(size: circleFontSize, weight: selected ? .bold : .medium))
    }
    
    //MARK: Item Drawing Constants
    private let circleFontSize: CGFloat = 30
    private var contentFontSize: CGFloat {
        circleFontSize - 5
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


struct ConditionalModifierView<Content: View>: View {
    let content: Content
    let condition: Bool
    
    init(condition: Bool, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.condition = condition
    }
    
    var body: some View {
        if condition {
            return content
        } else {
            return content
        }
    }
}

extension View {
   func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }
}
