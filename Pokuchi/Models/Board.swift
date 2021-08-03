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

struct Board {
   
   /** NOTE:
       Whenever we get a reference to an object on the game board (matrix), Swift will pass by value because we are building this in a struct.
       If we need to make edits, we need to edit on the matrix itself (matrix[row][col]). */
   
   // BOARD
   /** The game board.*/
   private var matrix: [[Cell]] = []
   /** The number of rows the board has. */
   var rows: Int { matrix.count }
   /** The number of columns the board has. */
   var columns: Int { matrix[0].count }
   
   
   // MINES
   /** The location of all mines on the board for quick lookup. */
   private var mineLocations = [BoardLocation]()
   /** The total number of mines on the board. */
   private let totalMines: Int
   
   
   // FLAGS
   /** The total number of flags placed by the user. */
   var placedFlags: Int {
      return totalMines - matrix.flatMap { $0 }.filter { matrix[$0.row][$0.col].cellState == .isFlagged }.count
   }
   /** Returns true if all the flags have been placed in the right locations.*/
   var minesCorrectlyFlagged: Bool {
      return mineLocations.allSatisfy { matrix[$0.row][$0.col].cellState == .isFlagged }
   }
   
   
   // CELLS
   /** Returns true if all the cells have been exposed or flagged. */
   var noCellsAreHidden: Bool {
      return matrix.flatMap { $0 }.allSatisfy { $0.cellState != .isHidden }
   }
   
   
   // INITIALIZATION
   
   init(rows: Int, columns: Int, totalMines: Int) {
      self.totalMines = totalMines > columns * rows ? (columns * rows) - 1 : totalMines
      self.buildBoard(rows: rows, columns: columns)
      self.placeMines()
      self.printBoard()
   }
}


// MARK: -
extension Board {
   
   /** Flag a cell. This method will check if the current node is has not been exposed yet.
       It then toggles between flagging the cell or removing the flag.*/
   mutating func toggleFlag(at location: BoardLocation) {
      self.matrix[location.row][location.col].toggleFlag()
   }
   
   /**
      This method will expose the cell at the current location, and any cells around it providing those cells are not mines.
    
    This method uses Breadth-First Search (BFS) to search its neighbors.
      
      # Breakdown
    
      1.    We first check that the cell is not a mine. if it is, we expose the cell and immediately return.
      2.    We create a queue and a temporary matrix to mark cells we have visited (this will prevent infinate loops).
      3.    We consume the nodes in the queue and expose the cells.
      4.    If the current node has a minesInProximity value of 0 (there are no mines around it), we search its neighbors.
      5.    We check if the current node is safely within bounds, and then check if the cell has not already been exposed, and that it is not a mine.
      6.    Finally we check if the current not has not already been visited. If it has not, we enqueue the node and set its visited value to true.
    
    */
   mutating func exposeCells(from location: BoardLocation) {
      let cell = matrix[location.row][location.col]
      
      // 1
      guard !cell.isMine else {
         self.matrix[location.row][location.col].exposeCell()
         return
      }
      
      // 2
      let queue = Queue<Cell>()
      var visited = Array(repeating: Array(repeating: false, count: self.columns), count: rows)
      
      queue.enqueue(matrix[location.row][location.col])
      visited[location.row][location.col] = true
      
      // 3
      while !queue.isEmpty {
         let node = queue.dequeue()

         self.matrix[node.row][node.col].exposeCell()
         
         // 4
         if node.minesInProximity == 0 {
            for delta in deltas {
               let row = node.row + delta[0]
               let col = node.col + delta[1]
               
               // 5
               if withinBounds(row, col) {
                  let adjacent = matrix[row][col]
                  if adjacent.cellState != .isExposed, !adjacent.isMine {
                     
                     // 6
                     if !visited[row][col] {
                        queue.enqueue(matrix[row][col])
                        visited[row][col] = true
                     }
                  }
               }
            }
         }
      }
   }
   
   // FIXME: - expose all cells
   // for end game state
   mutating func exposeAllCells(includingMines: Bool) {
      
   }
   
}


// MARK: - INITIALIZATION

extension Board {
   /** A method that builds out the game board.*/
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
   
   // FIXME: WE SHOULD PLACE MINES AND SHUFFLE BOARD
   // if we have a 100 cell board and 99 mines, the algorithm can take too long to place all the mines.
   // its better to place the mines first along with the empty cells, shuffle the board, and edit the board
   // numbers around the mines.
   
   /** This method randomly places mines onto the game board.*/
   private mutating func placeMines() {
      var mineCounter = self.totalMines
      
      while mineCounter > 0 {
         let row = Int.random(in: 0..<rows)
         let col = Int.random(in: 0..<columns)
         
         if cellAt(row, col).isMine == false {
            matrix[row][col].setAsMine()
            incrementMineBoundryCount(row, col)
            mineLocations.append(.init(row, col))
            mineCounter -= 1
         }
      }
   }
   
   /** This method increments the number in its boundary cells by one.
       We use this when we place a mine and need to update the minesInProximity
       property in its surrounding cells. */
   private mutating func incrementMineBoundryCount(_ row: Int, _ col: Int) {
      for delta in self.deltas {
         let row = row + delta[0]
         let col = col + delta[1]
         if withinBounds(row, col), cellAt(row, col).isMine == false {
            self.incrementAtPosition(row, col)
         }
      }
   }
   
   /** Increments the minesInProximity value of a cell by one.*/
   private mutating func incrementAtPosition(_ row: Int, _ col: Int) {
      self.matrix[row][col].updateMinesInProximityByOne()
   }
}


// MARK: -  HELPER FUNCTIONS

extension Board {
   /** A simple property used to calculate the position of the sorrounding cells of a cell.*/
   private var deltas: [[Int]] {
      [
         [-1, -1], [-1, 0], [-1, 1],
         [ 0, -1],          [ 0, 1],
         [ 1, -1], [ 1, 0], [ 1, 1]
      ]
   }

   /** A simple function to check whether a location is within the bounds of the game board.*/
   private func withinBounds(_ row: Int, _ col: Int) -> Bool {
      return row >= 0 && row < rows && col >= 0 && col < columns
   }
   
   /** Gets the cell at the location provided. NOTE: This will pass the cell by value.
       If we want to make edits, we need to edit the cell in the matrix (game board). */
   func cellAt(_ row: Int, _ col: Int) -> Cell {
      return matrix[row][col]
   }
}


// DEBUG
extension Board {

   /** Prints the game board to the console.*/
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
