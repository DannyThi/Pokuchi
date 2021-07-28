//
//  BoardView.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/26.
//

import SwiftUI

struct BoardView<ContentView>: View where ContentView: View {
   private let gridSize: Int
   private var gridSizeWithBoundary: Int { self.displaysBoundaryCells ? gridSize + 2 : gridSize }
   
   private let itemSize: CGFloat
   private let spacing: CGFloat
   
   private let displaysBoundaryCells: Bool
   private var content: (_ row: Int, _ column: Int) -> ContentView

   private var gridItems: [GridItem]
   
   
   init(gridSize: Int, itemSize: CGFloat? = 50, spacing: CGFloat? = 1,
        displaysBoundaryCells: Bool? = true, @ViewBuilder content: @escaping (Int, Int) -> ContentView) {
      
      self.gridSize = gridSize
      self.itemSize = itemSize!
      self.spacing = spacing!
      self.displaysBoundaryCells = displaysBoundaryCells!
      self.content = content
      
      self.gridItems = Array(repeating: GridItem(.fixed(itemSize!), spacing: spacing!),
                             count: displaysBoundaryCells! ? gridSize + 2 : gridSize)
   }
   
   var body: some View {
      buildBoard()
   }
   
   @ViewBuilder private func horizontalBoundaryCells(size: Int) -> some View {
      ForEach(0..<size) { index in
         if index == 0 || index == size - 1 {
            LabelCell(text: "")
         } else {
            LabelCell(text: "\(index-1)")
               .aspectRatio(1, contentMode: .fit)
         }
      }
   }
   
   
   @ViewBuilder private func buildBoard() -> some View {
      LazyVGrid(columns: self.gridItems, spacing: self.spacing) {
         
         // TOP BOUNDARY CELLS
         if self.displaysBoundaryCells {
            self.horizontalBoundaryCells(size: self.gridSizeWithBoundary)
         }
         
         ForEach(0..<gridSize) { row in
            // LEFT BOUNDARY CELL
            LabelCell(text: "\(row)")
            
            ForEach(0..<gridSize) { col in
               content(row, col)
            }
            
            // RIGHT BOUNDARY CELL
            LabelCell(text: "\(row)")
         }
         
         // BOTTOM BOUNDARY CELLS
         if self.displaysBoundaryCells {
            self.horizontalBoundaryCells(size: self.gridSizeWithBoundary)
         }
      }
   }
}
