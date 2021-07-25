//
//  ContentView.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/11.
//

import SwiftUI

struct ContentView: View {
   
   @ObservedObject var game: Game
   
   var body: some View {
      ScrollView {
         VStack {
            /*
             LazyVGrid takes in an array of GridItems. Each GridItem represents a
             column. GridItems can have enum values to determine how they are represented
             on screen (adaptive,fixed, etc.).
             */
            let gridItems = Array(repeating: GridItem(spacing: 1), count: game.columns)
            
            LazyVGrid(columns: gridItems, spacing: 1) {
               ForEach(0..<game.rows) { row in
                  ForEach(0..<game.columns) { col in
                     let cell = game.cellAt(row,col)
                     CellView(cell: cell)
                        .aspectRatio(1, contentMode: .fit)
                        .onTapGesture {
                           self.game.exposeCell(cell)
                        }
                  }
               }
            }
         }
      }
      .padding(.horizontal)
   }
}

struct CellView: View {
   var cell: Cell

   var body: some View {
      ZStack {
         /*
          We can declare temporary variables within view builders. This is useful
          when we have to use a copy of the item multiple items within the scope.
          */
         let shape = RoundedRectangle(cornerRadius: 5)
         
         if cell.isExposed {
            shape.fill().foregroundColor(.white)
            shape.stroke(lineWidth: 1.0)
            Text("\(cell.minesInProximity)").foregroundColor(Color(.black))
         } else {
            shape.fill().foregroundColor(.gray)
//            Text("\(cell.minesInProximity)").foregroundColor(Color(.black))

//            shape.stroke(lineWidth: 0.5).foregroundColor(.white)
         }
      }
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView(game: Game(rows: 10, columns: 10, mines: 10))
         .preferredColorScheme(.dark)
    }
}
