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
         
         if cell.isExposed {
            shape.fill().foregroundColor(.white)
            shape.stroke(lineWidth: 1.0)
            Text("\(cell.minesInProximity)").foregroundColor(Color(.black))
         } else {
            shape.fill().foregroundColor(.gray)
            if isSelected {
               shape.stroke(lineWidth: 1.0).foregroundColor(.red)
            }
//            Text("\(cell.minesInProximity)").foregroundColor(Color(.black))

         }
      }
   }
}
