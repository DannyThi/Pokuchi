//
//  NewGameMenu.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/08/20.
//

import SwiftUI

struct NewGameMenu: ViewModifier {
   
   @Binding var isPresented: Bool
   @Binding var difficulty: GameDifficulty?
   
   func body(content: Content) -> some View {
      if isPresented {
         content
            .actionSheet(isPresented: $isPresented) { gameSelectActionSheet }
      } else {
         content
      }
   }
   
   var gameSelectActionSheet: ActionSheet {
      ActionSheet(title: Text("Choose a difficulty"), buttons: [
         .cancel(),
         .default(Text("Easy"), action: { difficulty = .easy }),
         .default(Text("Medium"), action: { difficulty = .medium }),
         .default(Text("Hard"), action: { difficulty = .hard }),
         .default(Text("Insane"), action: { difficulty = .insane }),
      ])
   }
}

extension View {
   func newGameMenu(isPresented: Binding<Bool>, difficulty: Binding<GameDifficulty?>) -> some View {
      self.modifier(NewGameMenu(isPresented: isPresented, difficulty: difficulty))
   }
}


