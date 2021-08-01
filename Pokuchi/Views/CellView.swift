//
//  CellView.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/26.
//

import SwiftUI

struct CellView: View {
   var cell: Cell
   @Binding var isSelected: Bool

   var body: some View {
      ZStack {
         let shape = RoundedRectangle(cornerRadius: 5)
         
         if cell.cellState == .isExposed {
            self.exposedState(shape)
         } else {
            self.hiddenState(shape)
            self.flaggedState(shape)
         }
      }
   }
   
   @ViewBuilder private func exposedState<T: Shape>(_ shape: T) -> some View {
      shape.fill().foregroundColor(.white)
      shape.stroke(lineWidth: 1.0)
      if self.cell.isMine {
         Image(systemName: "star.fill")
      } else {
         Text("\(cell.minesInProximity)").foregroundColor(Color(.black))
      }
   }
   
   @ViewBuilder private func hiddenState<T: Shape>(_ shape: T) -> some View {
      shape.fill().foregroundColor(.gray)
      if isSelected {
         shape.stroke(lineWidth: 1.0).foregroundColor(.red)
      }
   }
   
   @ViewBuilder private func flaggedState<T: Shape>(_ shape: T) -> some View {
      if cell.cellState == .isFlagged {
         Image(systemName: "flag.fill")
      }
   }
   
   @ViewBuilder private func debugMode<T:Shape>(_ shape: T) -> some View {
      Text("\(cell.minesInProximity)").foregroundColor(Color(.black))
   }
}
