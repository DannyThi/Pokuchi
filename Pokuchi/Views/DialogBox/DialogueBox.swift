//
//  DialogueBox.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/08/11.
//

import SwiftUI

struct DialogBox<DialogContent: View>: ViewModifier {
   @Environment(\.colorScheme) private var colorScheme
   @Binding var isPresented: Bool
   
   @State private var contentSize: CGSize = .zero
   var dialogBoxContent: () -> DialogContent
   
   init(isPresented: Binding<Bool>, @ViewBuilder dialogBoxContent: @escaping () -> DialogContent) {
      self._isPresented = isPresented
      self.dialogBoxContent = dialogBoxContent
   }
   
   func body(content: Content) -> some View {
      if isPresented {
         content
            .overlay(
               GeometryReader { proxy in
                  let maxWidth = min(proxy.size.width, proxy.size.height) * 0.9
                  let maxHeight = min(contentSize.height, proxy.size.height * 0.85)
                  ZStack {
                     Color.black.opacity(0.5)
                     RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(colorScheme == .dark ? .gray : .white)
                        .frame(maxWidth: maxWidth, maxHeight: maxHeight)
                        .shadow(radius: 5)
                     dialogBoxContent().readSize { size in
                        self.contentSize = size
                     }
                  }
                  .edgesIgnoringSafeArea(.all)
               }
            )
      } else {
         content
      }
   }
}

extension View {
   func dialogBox<Content:View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
      self.modifier(DialogBox(isPresented: isPresented, dialogBoxContent: content))
   }
}
