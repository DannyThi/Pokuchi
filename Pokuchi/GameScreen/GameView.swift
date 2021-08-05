//
//  ContentView.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/11.
//

import SwiftUI

struct GameView: View {
   @Environment(\.presentationMode) var presentationMode
   
   @ObservedObject var game: Game
   @State var selectedCell: BoardLocation?
   
   private let itemSize: CGFloat = 50
   
   var body: some View {
      GeometryReader { geoProxy in
         VStack {
            GameViewHeader
            GameContainer(size: geoProxy.size)
            GameControls
            
            Spacer()
         }
      }
   }
   
   var GameViewHeader: some View {
      VStack {
         HStack {
            Button { presentationMode.wrappedValue.dismiss() }
            label: { Image(systemName: "chevron.left") }
            
            Spacer()
            
            Image(systemName: "deskclock.fill")
            Text("\(game.formattedTime)")
            
            Spacer()
            
            Image(systemName: "flag.fill")
            Text("\(game.placedFlags)")
         }
         Divider()
      }
      .padding()
   }
   
   @ViewBuilder
   private func GameContainer(size: CGSize) -> some View {
      VStack {
         ScrollView([.horizontal, .vertical], showsIndicators: false) {
            board
         }
         .frame(width: size.width, height: size.height * 0.7)
         Divider()
      }
   }
   
   private var board: some View {
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
   
   private var GameControls: some View {
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
         
         // NEWGAME
         Button {
            self.game.newGame()
         } label: {
            Text("New Game")
         }
         Spacer()
         
         // EXPOSE
         Button {
            if let location = selectedCell {
               let cell = self.game.cellAt(location.row, location.col)
               withAnimation {
                  self.game.exposeCell(cell)
               }
            }
         } label: {
            Text("Expose cell")
         }
      }
      .padding()
   }

}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      GameView(game: Game(rows: 10, columns: 10, mines: 10))
         .preferredColorScheme(.light)
   }
}
