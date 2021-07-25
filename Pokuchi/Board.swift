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
   
   private let totalMines: Int
   private var mineLocations = [BoardLocation]()

   var rows: Int { matrix.count }
   var columns: Int { matrix[0].count }
   
   var remainingMines: Int {
      let minesFlagged = mineLocations.filter { matrix[$0.row][$0.col].isFlagged }.count
      return totalMines - minesFlagged
   }
   
   init(rows: Int, columns: Int, totalMines: Int) {
      self.totalMines = totalMines > columns * rows ? (columns * rows) - 1 : totalMines
      self.buildBoard(rows: rows, columns: columns)
      self.placeMines()
      self.printBoard()
   }
   
   func flattened() -> [Cell] {
      return matrix.flatMap { $0 }
   }

   mutating func exposeCells(location: BoardLocation) {
      let queue = Queue<Cell>()
      
      queue.enqueue(matrix[location.row][location.col])
      
      var count:Int = 0
      
      while !queue.isEmpty {
         let node = queue.dequeue()
         self.matrix[node.row][node.col].isExposed = true // EXPOSE CELL
         
         count += 1
         
         if node.minesInProximity == 0 {
            for delta in deltas {
               let row = node.row + delta[0]
               let col = node.col + delta[1]
               
               if withinBounds(row, col) {
                  if !node.isExposed && !node.isMine {
                     queue.enqueue(matrix[row][col])
                  }
               }
            }
         }
         
         print("Queue: \(queue.count)")

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
   
   //TODO: WE SHOULD PLACE MINES AND SHUFFLE BOARD
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
