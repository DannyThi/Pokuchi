//
//  TitleScreenViewModel.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/08/04.
//

import Foundation
import Combine

class TitleScreenViewModel: ObservableObject {
      
   @Published var gameDifficulty: GameDifficulty?
   @Published var startGame: Bool = false
   
   private var cancellables = Set<AnyCancellable>()
   
   init() {
      $gameDifficulty
         .receive(on: RunLoop.main)
         .map { $0 != nil }
         .assign(to: \.startGame, on: self)
         .store(in: &cancellables)
   }
}
