//
//  Game.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/13.
//

import Foundation

class Game: ObservableObject {
   
   // PRIVATE
   @Published private var internalBoard: Board<String> // our model

   
   // PUBLIC
   var rows: Int { internalBoard.rows }
   var columns: Int { internalBoard.columns }
   
   init(rows: Int, columns: Int, mines: Int) {
      self.internalBoard = Board(rows: rows, columns: columns, totalMines: mines)
   }
   
   func cellAt(_ row: Int, _ col: Int) -> Cell {
      return internalBoard.cellAt(row, col)
   }
   
   func exposeCell(_ cell: Cell) {
      print("Tapped cell(x: \(cell.row), y: \(cell.col))")
      guard !cell.isExposed else {
         print("Cell is already exposed.")
         return
      }
      
      guard !cell.isMine else {
         print("CLICKED ON MINE: END GAME")
         //TODO: End game
         return
      }
      
      if !cell.isExposed {
         print("Tapped close to mine: \(cell.minesInProximity)")
         self.internalBoard.exposeCells(location: .init(cell.row, cell.col))
      }
      
      print("Cell Exposed: \(cell.minesInProximity)")
   }

}
