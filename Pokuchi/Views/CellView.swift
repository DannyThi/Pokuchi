//
//  CellView.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/26.
//

import SwiftUI

fileprivate struct ImageSeeds {
   static let grassSeedLimit = 10
}

struct CellView: View, Animatable {
   var cell: Cell
   @Binding var isSelected: Bool
   @State private var imageSeed: Int

   var animatableData: Double {
      get { rotation }
      set { rotation = newValue }
   }
   var rotation: Double = 0

   init(cell: Cell, isSelected: Binding<Bool>) {
      self.cell = cell
      self.imageSeed = Int.random(in: 0...ImageSeeds.grassSeedLimit)
      self._isSelected = isSelected
      rotation = cell.cellState == .isExposed ? 180 : 0
   }

   var body: some View {
      GeometryReader { proxy in
         ZStack {
            let shape = RoundedRectangle(cornerRadius: 5)

            if rotation > 90 {
               self.exposedState(shape)
            } else {
               GrassTile
               FlagTile
            }
         }
         .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
      }
   }
   
   private var GrassTile: some View {
      Image("grass_tile_\(imageSeed)")
         .resizable()
         .border(isSelected ? Color.red : Color.clear)
   }
   
   private var FlagTile: some View {
      Group {
         if cell.cellState == .isFlagged {
            Image("flag")
               .resizable()
         }
      }
   }

   @ViewBuilder private func exposedState<T: Shape>(_ shape: T) -> some View {
      Group {
         shape.fill().foregroundColor(.white)
         shape.stroke(lineWidth: 1.0)
         
         if self.cell.isMine {
            Image(systemName: "star.fill")
         } else {
            let displayText = cell.minesInProximity == 0 ? "" : "\(cell.minesInProximity)"
            Text(displayText).foregroundColor(Color(.black))
               .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0)
            )
         }
      }
   }
   
   @ViewBuilder private func hiddenState<Content: View>(_ content: Content) -> some View {
      ZStack {
         content
      }
      
   }
   

   @ViewBuilder private func debugMode<T:Shape>(_ shape: T) -> some View {
      Text("\(cell.minesInProximity)").foregroundColor(Color(.black))
   }
}
