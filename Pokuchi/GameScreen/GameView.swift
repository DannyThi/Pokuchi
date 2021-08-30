//
//  ContentView.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/11.
//

import SwiftUI

fileprivate struct Constants {
   static let showDialogBoxDelay: Double = 1
   static let boardHeightMultiplier: CGFloat = 0.6
   static let cellSize: CGFloat = 50
}

struct GameView: View {
   @Environment(\.presentationMode) private var presentationMode
   
   @StateObject var game: Game
   @State var selectedCell: BoardLocation?
   
   @State private var newGameDifficulty: GameDifficulty?
   @State private var showDialogBox: Bool = false
   @State private var showDifficultySelect: Bool = false
   @State private var startNewGame: Bool = false
   
   init(game: Game) {
      self._game = StateObject(wrappedValue: game)
   }
   
   var body: some View {
      GeometryReader { geoProxy in
         VStack {
            GameViewHeader
            GameContainer(size: geoProxy.size)
            GameControls
            Spacer()
         }
         .onChange(of: self.game.gameState) { GameStateChangeHandler(state: $0) }
         .dialogBox(isPresented: $showDialogBox) { DialogBoxContents }
         
         .newGameMenu(isPresented: $showDifficultySelect, difficulty: Binding {
            self.newGameDifficulty
         } set: { value in
//            self.newGameDifficulty = value
         })

         
      }
   }
}


// GAMESTATE

extension GameView {
   #warning("TODO")
   private func GameStateChangeHandler(state: GameState) {
      switch state {
      case .lose:
         DispatchQueue.main.asyncAfter(deadline: .now() + Constants.showDialogBoxDelay) {
            self.showDialogBox = true
         }
      default:
         print("Default")
      }
   }
}


// DIALOG BOX

extension GameView {
   private var DialogBoxContents: some View {
      VStack {
         Text("Start a new game?")
            .padding()
         
         HStack {
            Button { self.showDifficultySelect = true }
            label: { Text("New Game") }
               .foregroundColor(.white)
               .font(Font.system(size: 12, weight: .regular))
               .padding()
               .background(Color.blue)
               .cornerRadius(30)
            
            Spacer()
            
            Button { self.presentationMode.wrappedValue.dismiss() }
            label: { Text("Main Menu") }
               .foregroundColor(.white)
               .font(Font.system(size: 12, weight: .regular))
               .padding()
               .background(Color.green)
               .cornerRadius(30)
         }
         .padding()
      }
      .padding()
   }
}


// HEADER
extension GameView {
   var GameViewHeader: some View {
      VStack {
         ZStack {
            VStack {
               GameTimer
            }
            
            HStack {
               BackButton
               Spacer()
               FlagCounter
            }
         }
         .padding([.horizontal, .top])
         Divider()
      }
   }

   private var GameTimer: some View {
      HStack {
         Image("clock_icon")
            .resizable()
            .frame(width: 20, height: 20)
         Text("\(game.formattedTime)")
      }
   }
   
   private var BackButton: some View {
      HStack {
         Button { presentationMode.wrappedValue.dismiss() }
         label: { Image(systemName: "chevron.left") }
      }
   }
   
   private var FlagCounter: some View {
      HStack {
         Image("flag_icon")
            .resizable()
            .frame(width: 20, height: 20)
         Text("\(game.placedFlags)")
      }
   }
   
}

// GAMEBOARD
extension GameView {
   @ViewBuilder
   private func GameContainer(size: CGSize) -> some View {
      VStack {
         ScrollView([.horizontal, .vertical], showsIndicators: false) {
            board
         }
         .frame(width: size.width)
         .frame(minHeight: size.height * Constants.boardHeightMultiplier)
         Divider()
      }
   }
   
   private var board: some View {
      BoardView(gridSize: game.columns, itemSize: Constants.cellSize) { (row, col) in
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
         Spacer()
         FlagButton
         Spacer(minLength: 20)
         ExposeButton
         Spacer()
      }
      .padding()
   }
   
   var ExposeButton: some View {
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
         .foregroundColor(.white)
         .font(Font.system(size: 20, weight: .regular))
         .padding()
         .frame(height: 44)
         .frame(minWidth: 140)
         .background(Color.main)
         .cornerRadius(30)
   }
   
   var FlagButton: some View {
      Button {
         if let location = selectedCell {
            let cell = self.game.cellAt(location.row, location.col)
            self.game.flagCell(cell)
         }
      } label: {
         Text("Flag")
      }
         .foregroundColor(.white)
         .font(Font.system(size: 20, weight: .regular))
         .padding()
         .frame(height: 44)
         .frame(minWidth: 100)
         .background(Color.pink)
         .cornerRadius(30)
   }

}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      GameView(game: Game(rows: 10, columns: 10, mines: 10))
         .preferredColorScheme(.light)
   }
}
