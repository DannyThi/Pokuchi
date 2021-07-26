//
//  ContentView.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/11.
//

import SwiftUI

struct GameView: View {
   @ObservedObject var game: Game
   @State var selectedCell: BoardLocation?
   
   var body: some View {
      VStack {
         Group {
            ScrollView([.horizontal, .vertical]) {
               board
            }
         }
         .frame(width: 500, height: 500, alignment: .center)
         .padding()


         Button {
            if let location = selectedCell {
               let cell = self.game.cellAt(location.row, location.col)
               self.game.exposeCell(cell)
            }
         } label: {
            Text("Expose cell")
         }
         
      }
   }
   
   var board: some View {
      BoardView(gridSize: game.columns, itemSize: 50) { (row, col) in
         let cell = game.cellAt(row,col)
         let selected = Binding(get: { selectedCell?.row == cell.row && selectedCell?.col == cell.col },
                                set: { _ in })
         CellView(cell: cell, isSelected: selected)
            .aspectRatio(1, contentMode: .fit)
            .onTapGesture {
               selectedCell = BoardLocation(cell.row, cell.col)
            }
      }
   }

}

struct LabelCell: View {
   var text: String
   var body: some View {
      ZStack {
         let shape = RoundedRectangle(cornerRadius: 5)
         shape.fill().foregroundColor(Color(.white))
         shape.stroke(lineWidth: 1.0).foregroundColor(Color(.systemGray4))
         Text(text)
            .foregroundColor(Color(.systemGray4))
      }
   }
}



struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      GameView(game: Game(rows: 10, columns: 10, mines: 10))
         .preferredColorScheme(.light)
   }
}
