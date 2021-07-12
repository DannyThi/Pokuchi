//
//  Board.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/11.
//

import Foundation

struct Cell {
   let row: Int
   let col: Int
   var minesInProximity: Int = 0
   var isMine: Bool {
      minesInProximity == -1 ? true : false
   }
   
   var isExposed: Bool = false
   var isFlagged: Bool = false

   // RETURN TRUE IF THIS IS A MINE
   @discardableResult
   mutating func exposeCell() -> Bool {
      if !isFlagged && !isExposed {
         self.isExposed = true
      }
      return isMine
   }
   
   mutating func flag() {
      if !isExposed {
         self.isFlagged.toggle()
      }
   }
   
   
}

struct BoardLocation {
   let row: Int
   let col: Int
   
   init(_ row: Int, _ col: Int) {
      self.row = row
      self.col = col
   }
}


class Board: ObservableObject {
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

   func exposeCells(fromCell cell: Cell) {
      
   }
   /*
    public void expandBlank(Cell cell) {
       int[][] deltas = {
             {-1, -1}, {-1, 0}, {-1, 1},
             { 0, -1},          { 0, 1},
             { 1, -1}, { 1, 0}, { 1, 1}
       };
       
       Queue<Cell> toExplore = new LinkedList<Cell>();
       toExplore.add(cell);
       
       while (!toExplore.isEmpty()) {
          Cell current = toExplore.remove();
          
          for (int[] delta : deltas) {
             int r = current.getRow() + delta[0];
             int c = current.getColumn() + delta[1];
             
             if (inBounds(r, c)) {
                Cell neighbor = cells[r][c];
                if (flipCell(neighbor) && neighbor.isBlank()) {
                   toExplore.add(neighbor);
                }
             }
          }
       }
    }
    */

}

// INITIALIZATION
extension Board {
   private func buildBoard(rows: Int, columns: Int) {
      for col in 0..<columns {
         var fullRow = [Cell]()
         for row in 0..<rows {
            let cell = Cell(row: row, col: col)
            fullRow.append(cell)
         }
         self.matrix.append(fullRow)
      }
   }
   
   //TODO: WE SHOULD PLACE MINES AND SHUFFLE BOARD
   private func placeMines() {
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
   private func incrementMineBoundryCount(_ row: Int, _ col: Int) {
      for delta in self.deltas {
         let row = row + delta[0]
         let col = col + delta[1]
         if withinBounds(row, col), cellAt(row, col).isMine == false {
            incrementAtPosition(row, col)
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
   
   private func incrementAtPosition(_ row: Int, _ col: Int) {
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

/*
 
 public class Board {
    private int nRows;
    private int nColumns;
    private int nBombs = 0;
    private Cell[][] cells;
    private Cell[] bombs;
    private int numUnexposedRemaining;
    
    
    public Board(int r, int c, int b) {
       nRows = r;
       nColumns = c;
       nBombs = b;
       
       initializeBoard();
       shuffleBoard();
       setNumberedCells();
       
       numUnexposedRemaining = nRows * nColumns - nBombs;
    }
    
    private void initializeBoard() {
       cells = new Cell[nRows][nColumns];
       bombs = new Cell[nBombs];
       for (int r = 0; r < nRows; r++) {
          for (int c = 0; c < nColumns; c++) {
             cells[r][c] = new Cell(r, c);
          }
       }
       
       for (int i = 0; i < nBombs; i++) {
          int r = i / nColumns;
          int c = (i - r * nColumns) % nColumns;
          bombs[i] = cells[r][c];
          bombs[i].setBomb(true);
       }
    }
    
    private void shuffleBoard() {
       int nCells = nRows * nColumns;
       Random random = new Random();
       for (int index1 = 0; index1 < nCells; index1++) {
          int index2 = index1 + random.nextInt(nCells - index1);
          if (index1 != index2) {
             /* Get cell at index1. */
             int row1 = index1 / nColumns;
             int column1 = (index1 - row1 * nColumns) % nColumns;
             Cell cell1 = cells[row1][column1];
             
             /* Get cell at index2. */
             int row2 = index2 / nColumns;
             int column2 = (index2 - row2 * nColumns) % nColumns;
             Cell cell2 = cells[row2][column2];
             
             /* Swap. */
             cells[row1][column1] = cell2;
             cell2.setRowAndColumn(row1, column1);
             cells[row2][column2] = cell1;
             cell1.setRowAndColumn(row2, column2);
          }
       }
    }
    

    public void printBoard(boolean showUnderside) {
       System.out.println();
       System.out.print("   ");
       for (int i = 0; i < nColumns; i++) {
          System.out.print(i + " ");
       }
       System.out.println();
       for (int i = 0; i < nColumns; i++) {
          System.out.print("--");
       }
       System.out.println();
       for (int r = 0; r < nRows; r++) {
          System.out.print(r + "| ");
          for (int c = 0; c < nColumns; c++) {
             if (showUnderside) {
                System.out.print(cells[r][c].getUndersideState());
             } else {
                System.out.print(cells[r][c].getSurfaceState());
             }
          }
          System.out.println();
       }
    }
    
    private boolean flipCell(Cell cell) {
       if (!cell.isExposed() && !cell.isGuess()) {
          cell.flip();
          numUnexposedRemaining--;
          return true;
       }
       return false;
    }
    
    public void expandBlank(Cell cell) {
       int[][] deltas = {
             {-1, -1}, {-1, 0}, {-1, 1},
             { 0, -1},          { 0, 1},
             { 1, -1}, { 1, 0}, { 1, 1}
       };
       
       Queue<Cell> toExplore = new LinkedList<Cell>();
       toExplore.add(cell);
       
       while (!toExplore.isEmpty()) {
          Cell current = toExplore.remove();
          
          for (int[] delta : deltas) {
             int r = current.getRow() + delta[0];
             int c = current.getColumn() + delta[1];
             
             if (inBounds(r, c)) {
                Cell neighbor = cells[r][c];
                if (flipCell(neighbor) && neighbor.isBlank()) {
                   toExplore.add(neighbor);
                }
             }
          }
       }
    }
    
    public UserPlayResult playFlip(UserPlay play) {
       Cell cell = getCellAtLocation(play);
       if (cell == null) {
          return new UserPlayResult(false, GameState.RUNNING);
       }
       
       if (play.isGuess()) {
          boolean guessResult = cell.toggleGuess();
          return new UserPlayResult(guessResult, GameState.RUNNING);
       }
       
       boolean result = flipCell(cell);
       
       if (cell.isBomb()) {
          return new UserPlayResult(result, GameState.LOST);
       }
       
       if (cell.isBlank()) {
          expandBlank(cell);
       }
       
       if (numUnexposedRemaining == 0) {
          return new UserPlayResult(result, GameState.WON);
       }
       
       return new UserPlayResult(result, GameState.RUNNING);
    }
    
    public Cell getCellAtLocation(UserPlay play) {
       int row = play.getRow();
       int col = play.getColumn();
       if (!inBounds(row, col)) {
          return null;
       }
       return cells[row][col];
    }
    
    public int getNumRemaining() {
       return numUnexposedRemaining;
    }
 }
 */
