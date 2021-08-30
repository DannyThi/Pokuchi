//
//  CapsuleButton.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/08/30.
//

import SwiftUI

struct CapsuleButtonModifier: ViewModifier {
   private var color: Color
   
   init(color: Color = .blue) {
      self.color = color
   }
   
   func body(content: Content) -> some View {
      GeometryReader { proxy in
         content
            .foregroundColor(.white)
            .font(Font.system(size: 16, weight: .semibold))
            .padding()
            .frame(maxWidth: proxy.size.width)
            .background(Color.blue)
            .cornerRadius(30)
      }
   }
}

extension View {
   func makeCapsuleButton() -> some View {
      self.modifier(CapsuleButtonModifier())
   }
}


struct CapsuleButton_Previews: PreviewProvider {
   static var previews: some View {
      VStack {
         Button(action: {}, label: {
            Text("Button")
         }).makeCapsuleButton()
         HStack {
            Button(action: {}, label: {
               Text("Button")
            }).makeCapsuleButton()
            Button(action: {}, label: {
               Text("Button")
            }).makeCapsuleButton()
         }
         HStack {
            Button(action: {}, label: {
               Text("Button")
            }).makeCapsuleButton()
            Button(action: {}, label: {
               Text("Button")
            }).makeCapsuleButton()
            Button(action: {}, label: {
               Text("Button")
            }).makeCapsuleButton()
         }
      }
   }
}
