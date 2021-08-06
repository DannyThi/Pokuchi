//
//  Constants.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/08/06.
//

import SwiftUI

#warning("TO BE COMPLETED")
struct AppConstants {
   private init() {}
   static let shared = AppConstants()
   
   // PRIVATE
   private let appColors = AppColors()
   
   
   // PUBLIC
   var mainColor: UIColor { appColors.main }
//   var customDarkModeBlack: UIColor {}
   
   
   private struct AppColors {
      @Environment(\.colorScheme) private var colorScheme

      var main: UIColor {
         return UIColor(named: "AccentColor")!
      }
      
      
   }
}

extension Color {
   static var main: Color {
      Color(AppConstants.shared.mainColor)
   }
   
//   var customBackground: Color {
//
//   }
}
