//
//  SizePreferenceKey.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/08/20.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
   static var defaultValue: CGSize = .zero
   static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}

extension View {
   func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
      background(
         GeometryReader { proxy in
            Color.clear
               .preference(key: SizePreferenceKey.self, value: proxy.size)
         }
      )
      .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
   }
}
