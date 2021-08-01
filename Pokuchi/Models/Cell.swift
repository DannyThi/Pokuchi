//
//  Cell.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/11.
//

import Foundation

struct Cell: Identifiable, Hashable {
   let id = UUID().uuidString
   
   let row: Int
   let col: Int
   
   /** Denotes the number of mines within its ajacent border cells. A value of -1 is a mine.*/
   private(set) var minesInProximity: Int = 0
   
   /** Denotes that the current cell is a mine. */
   var isMine: Bool {
      minesInProximity == -1 ? true : false
   }
   
   /** The current state of the cell.
   # Cell States

    - **isFlagged** - The user has flagged this cell.
    - **isExposed** - The cell is exposed and the contents revealed. It could be blank, a number or a mine.
    - **isHidden** - We do not know what lies beneath this cell until we expose it.
    */
   private(set) var cellState: CellState = .isHidden
   
   /** Expose the current cell. */
   mutating func exposeCell() {
      if self.cellState != .isExposed {
         self.cellState = .isExposed
      }
   }
   
   /** Flag the current cell.*/
   mutating func toggleFlag() {
      guard self.cellState != .isExposed else {
         return
      }
      if self.cellState == .isHidden {
         self.cellState = .isFlagged
      } else {
         self.cellState = .isHidden
      }
   }

}

//MARK: - INITIALIZATION
extension Cell {
   /** Updates the minesInProximity value by one.*/
   mutating func updateMinesInProximityByOne() {
      self.minesInProximity += 1
   }
   
   /** Sets the minesInProximity value to -1 (denotes a mine).*/
   mutating func setAsMine() {
      self.minesInProximity = -1
   }
}

enum CellState {
   case isFlagged
   case isExposed
   case isHidden
}

