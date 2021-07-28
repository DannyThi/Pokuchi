//
//  LinkedList.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/13.
//

import Foundation

enum LinkedListError: Error {
   case indexOutOfBounds
}

class LinkedList<T: Hashable> {
   
   private(set) var head: Node<T>?
   private var tail: Node<T>?
   
   var isEmpty: Bool { self.head == nil }
   
   func append(value: T) {
      let node = LinkedList.Node(value)
      
      // We will always be setting the new node to the tail regardless of outcome.
      defer { self.tail = node }
      
      // If there is no tail, that means there is no list so set the new node
      // to the head (and eventually the tail through the defer method)
      guard let tail = self.tail else {
         self.head = node
         return
      }
      
      tail.next = node
   }
   
   @discardableResult
   func removeNode(at index: Int) -> T {
      guard self.tail != nil, index >= 0 else {
         preconditionFailure("Index out of range.")
      }
      
      var node = self.head
      var prev: Node<T>?
      
      var i = index
      
      while node != nil {
         if i == 0 {
            let value = node!.value
            if prev != nil {
               prev!.next = node!.next
            }
            return value
         }
         prev = node
         node = node!.next
         i -= 1
      }
      
      preconditionFailure("Index out of range.")
   }

   func node(at index: Int) -> T {
      guard index >= 0 else {
         preconditionFailure("Index out of range.")
      }
      
      var node = self.head
      var i = index
      
      // We count down to zero while jumping to the next node.
      while node != nil {
         if i == 0 { return node!.value }
         node = node!.next
         i -= 1
      }
      preconditionFailure("Index out of range.")
   }
   
   func removeAll() {
      self.head = nil
      self.tail = nil
   }
   
   public subscript(index: Int) -> T {
       return node(at: index)
   }
}

extension LinkedList {
   class Node<T> {
      var value: T
      var next: Node?
      
      init(_ value: T) {
         self.value = value
         self.next = nil
      }
   }
}
