//
//  TitleScreen.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/08/03.
//

import SwiftUI

struct TitleScreen: View {
   @Environment(\.colorScheme) var colorScheme
   @StateObject private var viewModel = TitleScreenViewModel()
   @State private var showGameSelect: Bool = false
   
   var body: some View {
      let gameDifficultyBinding = Binding(get: {
         self.viewModel.gameDifficulty
      }, set: { value in
         self.viewModel.gameDifficulty = value
      })
      
      VStack {
         Spacer()
         Title
         Spacer()
         StartButton
         Spacer()
      }
      .newGameMenu(isPresented: $showGameSelect, difficulty: gameDifficultyBinding)
      .fullScreenCover(isPresented: $viewModel.startGame) {
         GameView(game: viewModel.gameDifficulty!.game)
      }
   }
   
   var Title: some View {
      VStack {
         Text("Pokuchi")
            .font(.custom("Avenir Black", size: 60))
            .foregroundColor(Color(AppConstants.shared.mainColor))
         Text("A Mine Sweeper Game")
            .font(Font.system(size: 20, weight: .light))
            .foregroundColor(Color(.label))
      }
   }
   
   var StartButton: some View {
      Button {
         self.showGameSelect = true
      } label: {
         Text("Start")
            .foregroundColor(.white)
            .font(Font.system(size: 20, weight: .semibold))
            .padding()
            .frame(height: 60)
            .frame(maxWidth: 300)
            .background(Color.blue)
            .cornerRadius(30)
      }
   }
}



struct TitleScreen_Previews: PreviewProvider {
   static var previews: some View {
      TitleScreen()
         .preferredColorScheme(.light)
   }
}
