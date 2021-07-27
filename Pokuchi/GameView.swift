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
   
   private let itemSize: CGFloat = 50
   
   var body: some View {
      GeometryReader { geoProxy in
         VStack {
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
               board
            }
            .frame(width: geoProxy.size.width,
                   height: geoProxy.size.height * 0.7)
            
            Divider()
            
            buttons
            
            Spacer()
         }
      }
   }
   
   var board: some View {
      BoardView(gridSize: game.columns, itemSize: itemSize) { (row, col) in
         let cell = game.cellAt(row,col)
         let selected = Binding(get: { selectedCell?.row == cell.row && selectedCell?.col == cell.col },
                                set: { _ in })
         CellView(cell: cell, isSelected: selected)
            .aspectRatio(1, contentMode: .fit)
            .onTapGesture {
               selectedCell = BoardLocation(cell.row, cell.col)
            }
      }
      .padding()
   }
   
   var buttons: some View {
      HStack {
         // FLAG
         Button {
            if let location = selectedCell {
               let cell = self.game.cellAt(location.row, location.col)
               self.game.flagCell(cell)
            }
         } label: {
            Text("Flag")
         }
         
         Spacer()
         // EXPOSE
         Button {
            if let location = selectedCell {
               let cell = self.game.cellAt(location.row, location.col)
               self.game.exposeCell(cell)
            }
         } label: {
            Text("Expose cell")
         }
      }
      .padding()
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
