//
//  ContentView.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/11.
//

import SwiftUI

struct ContentView: View {
   var cellContent = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁","🐮"]
   @State var count = 11
   var body: some View {
      ScrollView {
         VStack {
            LazyVGrid(columns: [GridItem(),GridItem()]) {
               ForEach(cellContent[0..<count], id: \.self) { emoji in
                  CellView(content: emoji)
                     .aspectRatio(1, contentMode: .fit)
               }
            }
            .foregroundColor(.red)
         }
      }
      .padding(.horizontal)
   }
}

struct CellView: View {
   @State var isFaceUp: Bool = true
   var content: String

   var body: some View {
      ZStack {
         let shape = RoundedRectangle(cornerRadius: 10)
         if isFaceUp {
            shape.fill().foregroundColor(.white)
            shape.stroke(lineWidth: 2)
            Text(content).font(.largeTitle)
         } else {
            shape.fill()
         }
      }
      .onTapGesture {
         isFaceUp = !isFaceUp
      }
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
         .preferredColorScheme(.dark)
    }
}
