//
//  Cell.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/11.
//

import Foundation

enum CellState {
   case isFlagged
   case isGuess
   case isExposed
}

struct Cell: Identifiable, Hashable {
   let id = UUID().uuidString
   
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
      if !isExposed 
         self.isFlagged.toggle()
      }
   }
}


enum CellState {
   case isMine
   case isInProximityToMines(Int)
   case isEmpty
}
