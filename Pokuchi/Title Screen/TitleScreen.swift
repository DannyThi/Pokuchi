//
//  TitleScreen.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/08/03.
//

import SwiftUI

struct TitleScreen: View {
   
   @StateObject private var viewModel = TitleScreenViewModel()
   
   @State private var showGameSelect: Bool = false
   
   var body: some View {
      VStack {
         Spacer()
         VStack {
            Text("Pokuchi")
               .font(.largeTitle)
            Text("A Mine Sweeper Game")
               .font(.subheadline)
         }
         .padding()
         Spacer()
         
         Button {
            self.showGameSelect = true
         } label: {
            Text("Start")
               .foregroundColor(.white)
               .font(.headline)
               .padding()
               .frame(width: 300, height: 60)
               .background(Color.blue)
               .cornerRadius(30)
         }
         Spacer()
      }
      .actionSheet(isPresented: $showGameSelect) { gameSelectActionSheet }
      .fullScreenCover(isPresented: $viewModel.startGame) { GameView(game: viewModel.gameDifficulty!.game) }
   }
   
   var gameSelectActionSheet: ActionSheet {
      ActionSheet(title: Text("Choose a difficulty"), buttons: [
         .cancel(),
         .default(Text("Easy"), action: { viewModel.gameDifficulty = .easy }),
         .default(Text("Medium"), action: { viewModel.gameDifficulty = .medium }),
         .default(Text("Hard"), action: { viewModel.gameDifficulty = .hard }),
         .default(Text("Insane"), action: { viewModel.gameDifficulty = .insane }),
      ])
   }

}



struct TitleScreen_Previews: PreviewProvider {
   static var previews: some View {
      TitleScreen()
         .preferredColorScheme(.light)
   }
}
