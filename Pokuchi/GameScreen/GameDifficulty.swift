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
   
   var game: Game {
      switch self {
      case .easy:    return Game(rows: 5, columns: 5, mines: 5)
      case .medium:  return Game(rows: 10, columns: 10, mines: 10)
      case .hard:    return Game(rows: 15, columns: 15, mines: 50)
      case .insane:  return Game(rows: 20, columns: 20, mines: 100)
      case .debug:   return Game(rows: 10, columns: 10, mines: 3)

      case let .custom(rows, cols, mines):
         return Game(rows: rows, columns: cols, mines: mines)
      }
   }
   
   var gameData: GameData {
      switch self {
      case .easy:    return (5, 5, 5)
      case .medium:  return (10, 10, 10)
      case .hard:    return (15, 15, 50)
      case .insane:  return (20, 20, 100)
      case .debug:   return (10, 10, 3)
         
      case let .custom(rows, cols, mines):
         return (rows,cols,mines)
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
