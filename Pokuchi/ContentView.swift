//
//  ContentView.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/11.
//

import SwiftUI

struct ContentView: View {
   @ObservedObject var board: Board
   
   var body: some View {
      Text("Hello, world!")
         .padding()
      
      
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView(board: Board(rows: 5, columns: 5, totalMines: 3))
    }
}
