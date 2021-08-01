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
   var minesInProximity: Int = 0
   
   /** Denotes that the current cell is a mine. */
   var isMine: Bool {
      minesInProximity == -1 ? true : false
   }
   
   /** The current state of the cell.
    
   # Cell States

    - **isFlagged** - The use has flagged this cell.
    - **isExposed** - The cell is exposed and the contents revealed. It could be blank, a number or a mine.
    - **isHidden** - We do not know what lies beneath this cell until we expose it.
    */
   var cellState: CellState = .isHidden
   
//   /** Expose the current cell. */
//   mutating func exposeCell() {
//      if self.cellState == .isHidden {
//         self.cellState = .isExposed
//      }
//   }
   
   /** Flag the current cell.*/
   mutating func flag() {
      if self.cellState == .isHidden {
         self.cellState = .isFlagged
      }
   }
}

enum CellState {
   case isFlagged
   case isExposed
   case isHidden
}

