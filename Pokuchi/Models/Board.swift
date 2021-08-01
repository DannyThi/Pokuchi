//
//  Board.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/11.
//

import Foundation

struct BoardLocation {
   let row: Int
   let col: Int
   init(_ row: Int, _ col: Int) {
      self.row = row
      self.col = col
   }
}

struct Board<CellContent> {
   private var matrix: [[Cell]] = []
   
   private var mineLocations = [BoardLocation]()
   
   let totalMines: Int
   var rows: Int { matrix.count }
   var columns: Int { matrix[0].count }
   
   // To determine win state
//   var correctlyFlagged: Int {
//      let minesFlagged = mineLocations.filter { matrix[$0.row][$0.col].isFlagged }.count
//      return totalMines - minesFlagged
//   }
   
   var correctlyFlagged: Int {
      let minesFlagged = mineLocations.filter { matrix[$0.row][$0.col].cellState == .isFlagged }.count
      return totalMines - minesFlagged
   }
   
//   var placedFlags: Int {
//      return totalMines - matrix.flatMap { $0 }.filter { matrix[$0.row][$0.col].isFlagged }.count
//   }
//
   var placedFlags: Int {
      return totalMines - matrix.flatMap { $0 }.filter { matrix[$0.row][$0.col].cellState == .isFlagged }.count
   }
   
   init(rows: Int, columns: Int, totalMines: Int) {
      self.totalMines = totalMines > columns * rows ? (columns * rows) - 1 : totalMines
      self.buildBoard(rows: rows, columns: columns)
      self.placeMines()
      self.printBoard()
   }
   
//   mutating func flagCell(at location: BoardLocation) {
//      if !matrix[location.row][location.col].isExposed {
//         self.matrix[location.row][location.col].isFlagged.toggle()
//      }
//   }
   
   mutating func flagCell(at location: BoardLocation) {
      if matrix[location.row][location.col].cellState == .isHidden {
         self.matrix[location.row][location.col].cellState = .isFlagged
      } else {
         self.matrix[location.row][location.col].cellState = .isHidden
      }
   }
   
   mutating func exposeCells(from location: BoardLocation) {
      let cell = matrix[location.row][location.col]
//      guard !cell.isMine else {
//         self.matrix[location.row][location.col].isExposed = true
//         return
//      }
      guard !cell.isMine else {
         self.matrix[location.row][location.col].cellState = .isExposed
         return
      }
      
      let queue = Queue<Cell>()
      var visited = Array(repeating: Array(repeating: false, count: self.columns), count: rows)
      
      queue.enqueue(matrix[location.row][location.col])
      visited[location.row][location.col] = true
//      var count:Int = 0
      
      while !queue.isEmpty {
         let node = queue.dequeue()

//         self.matrix[node.row][node.col].isExposed = true // EXPOSE CELL
         self.matrix[node.row][node.col].cellState = .isExposed // EXPOSE CELL

//         count += 1
         
         if node.minesInProximity == 0 {
            for delta in deltas {
               let row = node.row + delta[0]
               let col = node.col + delta[1]
               
               if withinBounds(row, col) {
                  let adjacent = matrix[row][col]
//                  if !adjacent.isFlagged, !adjacent.isExposed, !adjacent.isMine {
                  if adjacent.cellState == .isHidden, !adjacent.isMine {
                     if !visited[row][col] {
                        queue.enqueue(matrix[row][col])
                        visited[row][col] = true
                     }
                  }
               }
            }
         }
         
//         print("Queue: \(queue.count)")
      }
   }
   
}

// INITIALIZATION
extension Board {
   private mutating func buildBoard(rows: Int, columns: Int) {
      for row in 0..<rows {
         var fullRow = [Cell]()
         for col in 0..<columns {
            let cell = Cell(row: row, col: col)
            fullRow.append(cell)
         }
         self.matrix.append(fullRow)
      }
   }
   
   // TODO: WE SHOULD PLACE MINES AND SHUFFLE BOARD
   // if we have a 100 cell board and 99 mines, the algorithm can take too long to place all the mines.
   // its better to place the mines first along with the empty cells, shuffle the board, and edit the board
   // numbers around the mines.
   private mutating func placeMines() {
      var mineCounter = self.totalMines
      
      while mineCounter > 0 {
         let row = Int.random(in: 0..<rows)
         let col = Int.random(in: 0..<columns)
         
         if cellAt(row, col).isMine == false {
            matrix[row][col].minesInProximity = -1
            incrementMineBoundryCount(row, col)
            mineLocations.append(.init(row, col))
            mineCounter -= 1
         }
      }
   }
   

   // CHECK BOUNDRY AND INCREMENT NUMBER BY 1
   private mutating func incrementMineBoundryCount(_ row: Int, _ col: Int) {
      for delta in self.deltas {
         let row = row + delta[0]
         let col = col + delta[1]
         if withinBounds(row, col), cellAt(row, col).isMine == false {
            self.incrementAtPosition(row, col)
         }
      }
   }
}


// HELPER FUNCTIONS
extension Board {
   
   private var deltas: [[Int]] {
      [
         [-1, -1], [-1, 0], [-1, 1],
         [ 0, -1],          [ 0, 1],
         [ 1, -1], [ 1, 0], [ 1, 1]
      ]
   }

   private func withinBounds(_ row: Int, _ col: Int) -> Bool {
      return row >= 0 && row < rows && col >= 0 && col < columns
   }
   
   private mutating func incrementAtPosition(_ row: Int, _ col: Int) {
      self.matrix[row][col].minesInProximity += 1
   }
   
   func cellAt(_ row: Int, _ col: Int) -> Cell {
      return matrix[row][col]
   }
}


// DEBUG
extension Board {
   private func printBoard() {
      for col in 0..<columns {
         print("||", terminator: "")
         for row in 0..<rows {
            var text = " "
            if cellAt(row, col).minesInProximity >= 0 {
               text += " "
            }
            print(text + "\(cellAt(row, col).minesInProximity) |", terminator: "")
         }
         print("|")
      }
   }
}
