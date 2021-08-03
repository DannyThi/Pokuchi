//
//  CellView.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/26.
//

import SwiftUI

struct CellView: View, Animatable {
   var cell: Cell
   @Binding var isSelected: Bool

   var animatableData: Double {
      get { rotation }
      set { rotation = newValue }
   }
   var rotation: Double = 0

   init(cell: Cell, isSelected: Binding<Bool>) {
      self.cell = cell
      self._isSelected = isSelected
      rotation = cell.cellState == .isExposed ? 180 : 0
   }

   var body: some View {
      
//      ZStack {
//         // card
//         let shape = Color.clear.cornerRadius(5)
//         if rotation > 90 {
//            shape.foregroundColor(.white)
//         } else {
//            shape.foregroundColor(.green)
//         }
//
//         if cell.cellState == .isFlagged {
//
//         }
//      }
      
      ZStack {
         let shape = RoundedRectangle(cornerRadius: 5)
         if rotation > 90 {
            self.exposedState(shape)
         } else {
            self.hiddenState(shape)
            self.flaggedState()
         }
      }
      .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
   }

   @ViewBuilder private func exposedState<T: Shape>(_ shape: T) -> some View {
      Group {
         shape.fill().foregroundColor(.white)
         shape.stroke(lineWidth: 1.0)
         
         if self.cell.isMine {
            Image(systemName: "star.fill")
         } else {
            Text("\(cell.minesInProximity)").foregroundColor(Color(.black))
               .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0)
            )
         }
      }
   }

   @ViewBuilder private func hiddenState<T: Shape>(_ shape: T) -> some View {
      shape.fill().foregroundColor(.green)
      if isSelected {
         shape.stroke(lineWidth: 2.0).foregroundColor(.red)
      }
   }

   @ViewBuilder private func flaggedState() -> some View {
      if cell.cellState == .isFlagged {
         Image(systemName: "flag.fill")
      }
   }

   @ViewBuilder private func debugMode<T:Shape>(_ shape: T) -> some View {
      Text("\(cell.minesInProximity)").foregroundColor(Color(.black))
   }
}
