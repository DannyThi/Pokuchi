//
//  PokuchiTests.swift
//  PokuchiTests
//
//  Created by Hai Long Danny Thi on 2021/07/13.
//

import XCTest
@testable import Pokuchi

class PokuchiTests: XCTestCase {
   
   func testLinkedListFunctions() {
      let list = LinkedList<Int>()
      
      list.append(value: 10)
      XCTAssertTrue(list[0] == 10)
      
      list.append(value: 20)
      list.removeNode(at: 0)
      XCTAssert(list[0] == 10)
      

      
   }

}
