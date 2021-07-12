//
//  Cell.swift
//  Pokuchi
//
//  Created by Hai Long Danny Thi on 2021/07/11.
//

import Foundation

struct CellModel {
   let row: Int
   let col: Int
   
   private(set) var isGuess: Bool = false
   private(set) var isRevealed: Bool = false
   
   private(set) var isBomb: Bool
   private(set) var number: Int

   init(row: Int, col: Int, isBomb: Bool, number: Int = 0) {
      self.row = row
      self.col = col
      self.isBomb = isBomb
      self.number = number
   }
   
   // Returns true if its a bomb
   mutating func flip() -> Bool {
      self.isRevealed = true
      return !isBomb
   }
   
   mutating func increaseNumber() {
      self.number += 1
   }
   
   mutating func toggleGuess() -> Bool {
      if !isRevealed {
         
         isGuess.toggle()
      }
      return isGuess
   }
}




/*

 
 public void setRowAndColumn(int r, int c) {
    row = r;
    column = c;
 }
 
 public void setBomb(boolean bomb) {
    isBomb = bomb;
    number = -1;
 }
 
 public boolean isBlank() {
    return number == 0;
 }
 
 
 @Override
 public String toString() {
    return getUndersideState();
 }
 
 public String getSurfaceState() {
    if (isExposed) {
       return getUndersideState();
    } else if (isGuess) {
       return "B ";
    } else {
       return "? ";
    }
 }
 
 public String getUndersideState() {
    if (isBomb) {
       return "* ";
    } else if (number > 0) {
       return Integer.toString(number) + " ";
    } else {
       return "  ";
    }
 }
 
 */

