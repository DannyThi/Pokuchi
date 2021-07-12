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
            ContentView(board: Board(rows: 10, columns: 10, totalMines: 5))
        }
    }
}
