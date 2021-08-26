//
//  CellView.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/26.
//

import SwiftUI

fileprivate struct Constants {
   static let grassTile = "grass_tile_"
   static let flagTile = "flag_tile"
   static let explosion = "explosion"
   static let earthTile = "earth_tile_"
   
   static let grassSeedLimit = 10
   static let earthSeedLimit = 5
}

struct CellView: View, Animatable {
   var cell: Cell
   
   @Binding var isSelected: Bool
   @State private var grassSeed: Int
   @State private var earthSeed: Int

   var animatableData: Double {
      get { rotation }
      set { rotation = newValue }
   }
   var rotation: Double = 0
   var animationDelay: Double = 0

   init(cell: Cell, isSelected: Binding<Bool>) {
      self.cell = cell
      self.grassSeed = Int.random(in: 0...Constants.grassSeedLimit)
      self.earthSeed = Int.random(in: 0...Constants.earthSeedLimit)
      self._isSelected = isSelected
      rotation = cell.cellState == .isExposed ? 180 : 0
   }

   var body: some View {
      GeometryReader { proxy in
         ZStack {
            if rotation > 90 {
               EarthTile
            } else {
               GrassTile
               FlagTile
            }
         }
         .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
         .animation(.easeInOut.delay(animationDelay))
      }
   }
   
   private var EarthTile: some View {
      ZStack {
         Image(Constants.earthTile + "\(earthSeed)")
            .resizable()
         if self.cell.isMine {
            Image(Constants.explosion)
               .resizable()
         } else {
            let displayText = cell.minesInProximity == 0 ? "" : "\(cell.minesInProximity)"
            Text(displayText).foregroundColor(Color(.white))
               .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0)
            )
         }
      }
   }
   
   private var GrassTile: some View {
      Group {
         Image(Constants.grassTile + "\(grassSeed)")
            .resizable()
         if isSelected {
            RoundedRectangle(cornerRadius: 5)
               .strokeBorder(Color.red, lineWidth: 3)
         }
      }
   }

   private var FlagTile: some View {
      Group {
         if cell.cellState == .isFlagged {
            Image(Constants.flagTile)
               .resizable()
         }
      }
   }

//   @ViewBuilder private func exposedState<T: Shape>(_ shape: T) -> some View {
//      Group {
//         shape.fill().foregroundColor(.white)
//         shape.stroke(lineWidth: 1.0)
//
//         if self.cell.isMine {
//            Image(Constants.explosion)
//               .resizable()
//         } else {
//            let displayText = cell.minesInProximity == 0 ? "" : "\(cell.minesInProximity)"
//            Text(displayText).foregroundColor(Color(.black))
//               .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0)
//            )
//         }
//      }
//   }


   @ViewBuilder private func debugMode<T:Shape>(_ shape: T) -> some View {
      Text("\(cell.minesInProximity)").foregroundColor(Color(.black))
   }
}
