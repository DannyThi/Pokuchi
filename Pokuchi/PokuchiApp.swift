//
//  PokuchiApp.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/11.
//

import SwiftUI

@main
struct PokuchiApp: App {
    var body: some Scene {
        WindowGroup {
            GameView(game: Game(rows: 10, columns: 10, mines: 5))
        }
    }
}
