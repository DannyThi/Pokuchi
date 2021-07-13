//
//  Queue.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/13.
//

import Foundation

class Queue<T> {
   private var first: Node<T>?
   private var last: Node<T>?
   
   func peek() -> T? {
      self.first?.value
   }
   
   func enqueue(_ value: T) {
      let node = Node(value: value)
      if last != nil {
         self.last!.next = node     // Point last's next value to node
      }
      self.last = node              // Our node is now the last item
      if first == nil {
         self.first = self.last     // Our last item is also our first item if we have no items.
      }
   }
   
   func dequeue() -> T {
      guard let value = self.first?.value else {
         fatalError("No value to dequeue")
      }
      self.first = self.first?.next
      if self.first == nil {
         self.last = nil
      }
      return value
   }
   
   var isEmpty: Bool {
      self.first == nil
   }
}


extension Queue {
   class Node<T> {
      var value: T
      var next: Node<T>?
      
      init(value: T) {
         self.value = value
      }
   }
}
