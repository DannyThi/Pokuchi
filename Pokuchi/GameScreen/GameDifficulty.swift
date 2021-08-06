//
//  GameDifficulty.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/08/04.
//

import Foundation

typealias GameData = (rows: Int, cols: Int, mines: Int)

enum GameDifficulty: Identifiable, RawRepresentable {
   case easy, medium, hard, insane, debug
   case custom(rows: Int, cols: Int, mines: Int)
   
   var gameData: GameData {
      switch self {
      case .easy:    return (8, 8, 10)
      case .medium:  return (12, 12, 15)
      case .hard:    return (12, 12, 30)
      case .insane:  return (20, 20, 30)
      case .debug:   return (10, 10, 3)
         
      case let .custom(rows, cols, mines):
         return (rows,cols,mines)
      }
   }
   
   var game: Game {
      switch self {
      case let .custom(rows, cols, mines):
         return Game(rows: rows, columns: cols, mines: mines)
         
      default:
         return Game(rows: self.gameData.rows, columns: self.gameData.cols, mines: self.gameData.mines)
      }
   }
   
   var id: String { return self.rawValue }
   
   init?(rawValue: String) {
      switch rawValue {
      case "easy":      self = .easy
      case "medium":    self = .medium
      case "hard":      self = .hard
      case "insane":    self = .insane
      case "debug":     self = .debug
      
      default:
         self = .custom(rows: 1, cols: 1, mines: 1)
      }
   }
   
   var rawValue: String {
      switch self {
      case .easy:    return "easy"
      case .medium:  return "medium"
      case .hard:    return "hard"
      case .insane:  return "insane"
      case .debug:    return "debug"
      case let .custom(rows, cols, mines):
         return "custom - rows: \(rows), columns: \(cols), mines: \(mines)"
      }
   }
   
}
