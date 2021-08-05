//
//  Constants.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/08/06.
//

import SwiftUI

struct AppConstants {
   @Environment(\.colorScheme) var colorScheme
   
   static var shared = AppConstants()
   private init() {}
   
   var mainColor: UIColor {
      return colorScheme == .light ?
         UIColor(red: 18/255, green: 135/255, blue: 28/255, alpha: 1) :
         UIColor(red: 18/255, green: 135/255, blue: 28/255, alpha: 1)
   }
   
   var customeDarkModeBlack: UIColor {
      return .black
   }
   
   
}
