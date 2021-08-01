//
//  Game.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/13.
//

import Foundation

enum GameState {
   case win
   case lose
   case running
}

class Game: ObservableObject {
   
   // PRIVATE
   @Published private var internalBoard: Board<String> // our model
   @Published private(set) var gameState: GameState = .running
   
   @Published private var runningTime: TimeInterval = 0
   
   private lazy var timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      self.updateTimer()
   }
   
   // PUBLIC
   var rows: Int { internalBoard.rows }
   var columns: Int { internalBoard.columns }
   var numberOfMines: Int { internalBoard.totalMines }
   
   var placedFlags: Int {
      return internalBoard.placedFlags
   }
   
   var formattedTime: String {
      return formattedTime(runningTime)
   }
   
   init(rows: Int, columns: Int, mines: Int) {
      self.internalBoard = Board(rows: rows, columns: columns, totalMines: mines)
      
      self.timer.tolerance = 0.01
      RunLoop.current.add(timer, forMode: .common)
      self.timer.fire()
      
   }
   
   private func updateTimer() {
      if gameState == .running {
         self.runningTime += 1
      }
   }

   func flagCell(at location: BoardLocation) {
      if gameState == .running {
         self.internalBoard.flagCell(at: location)
      }
//      self.checkWinCondition()
   }
   
   func exposeCell(_ cell: Cell) {
      if gameState == .running {
         print("Tapped cell(x: \(cell.row), y: \(cell.col))")
         guard !cell.isExposed else {
            return
         }
         
         self.internalBoard.exposeCells(from: .init(cell.row, cell.col))
         
         if cell.isMine {
            self.gameState = .lose
            print("Mine: END Game")
         }
         
         self.checkWinCondition()
      }
   }
   
   private func checkWinCondition() {
      if internalBoard.correctlyFlagged == 0 {
         self.gameState = .win
      }
   }

   func newGame() {
      self.runningTime = 0
      self.internalBoard = Board(rows: 10, columns: 10, totalMines: 5)
      self.gameState = .running
   }
}


// HELPER FUNCTIONS
extension Game {
   func flagCell(_ cell: Cell) {
      let location = BoardLocation(cell.row, cell.col)
      self.flagCell(at: location)
   }
   
   func cellAt(_ row: Int, _ col: Int) -> Cell {
      return internalBoard.cellAt(row, col)
   }
   
   private func formattedTime(_ rawTime: TimeInterval) -> String {
       let timeAsInt = Int(rawTime)
       let seconds = timeAsInt % 60
       let minutes = (timeAsInt / 60) % 60
//       let hours = timeAsInt / 3600
//       let milliseconds = Int(rawTime.truncatingRemainder(dividingBy: 1) * 100)

       return String(format: "%02i:%02i", minutes, seconds)
   }
}
