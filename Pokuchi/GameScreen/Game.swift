//
//  Game.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/13.
//

import Foundation
import Combine

enum GameState {
   case win
   case lose
   case running
}

fileprivate struct Constants {
   static var showdialogBoxTimeInterval: Double = 2
   static var timerStartDelay: Double = 2
}

class Game: ObservableObject {
   
   // PRIVATE
   @Published private var internalBoard: Board // our model
   @Published private(set) var gameState: GameState = .running
   @Published private var runningTime: TimeInterval = 0

   @Published var showDialogBox: Bool = false
   
   private lazy var timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      self.updateTimer()
   }
   
   private var cancellables = Set<AnyCancellable>()
   
   // PUBLIC
   var rows: Int { internalBoard.rows }
   var columns: Int { internalBoard.columns }
   
   /** Flags placed by the user.*/
   var placedFlags: Int { internalBoard.placedFlags }
   
   /** The running time user-readable formatted.*/
   var formattedTime: String { formattedTime(runningTime) }
   
   // INITIALIZATION
   convenience init(difficulty: GameDifficulty) {
      let data = difficulty.gameData
      self.init(rows: data.rows, columns: data.cols, mines: data.mines)
   }
   
   init(rows: Int, columns: Int, mines: Int) {
      self.internalBoard = Board(rows: rows, columns: columns, totalMines: mines)
      self.timer.tolerance = 0.01
      RunLoop.current.add(timer, forMode: .common)
      DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timerStartDelay) {
         self.timer.fire()
      }
      
      $gameState
         .receive(on: RunLoop.main)
         .sink { value in
            switch value {
            case .lose:
               print("LOSE")
               self.endGame()
            case .win:
               print("WIN")
            case .running:
               print("RUNNING")
            }
         }
         .store(in: &cancellables)
   }
   
   
   // METHODS
   private func updateTimer() {
      if gameState == .running {
         self.runningTime += 1
      }
   }

   func flagCell(at location: BoardLocation) {
      if gameState == .running {
         self.internalBoard.toggleFlag(at: location)
      }
      self.checkWinCondition()
   }
   
   func exposeCell(_ cell: Cell) {
      if gameState == .running {
         print("Tapped cell(row: \(cell.row), col: \(cell.col))")
         guard cell.cellState != .isExposed else { return }
         
         self.internalBoard.exposeCells(from: .init(cell.row, cell.col))
         if cell.isMine {
            self.gameState = .lose
         }
         self.checkWinCondition()
      }
   }
   

   
   /** Determines if the game is won.*/
   private func checkWinCondition() {
      if internalBoard.minesCorrectlyFlagged && internalBoard.noCellsAreHidden {
         self.gameState = .win
         print("WIN")
      }
   }
   
   func endGame() {
//      self.internalBoard.exposeMines()
      DispatchQueue.main.asyncAfter(deadline: .now() + Constants.showdialogBoxTimeInterval) {
         self.showDialogBox = true
      }
   }

   static func newGame(difficulty: GameDifficulty) -> Game {
      return Game(difficulty: difficulty)
   }
}


// HELPER FUNCTIONS
extension Game {
   
   /** Flag a cell by passing in the cell.*/
   func flagCell(_ cell: Cell) {
      let location = BoardLocation(cell.row, cell.col)
      self.flagCell(at: location)
   }
   
   /** Gets the cell at location.*/
   func cellAt(_ row: Int, _ col: Int) -> Cell {
      return internalBoard.cellAt(row, col)
   }
   
   /** This method formats the current running time into something more user readable.*/
   private func formattedTime(_ rawTime: TimeInterval) -> String {
       let timeAsInt = Int(rawTime)
       let seconds = timeAsInt % 60
       let minutes = (timeAsInt / 60) % 60
//       let hours = timeAsInt / 3600
//       let milliseconds = Int(rawTime.truncatingRemainder(dividingBy: 1) * 100)

       return String(format: "%02i:%02i", minutes, seconds)
   }
}
