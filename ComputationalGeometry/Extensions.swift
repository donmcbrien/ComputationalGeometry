//
//  Extensions.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 25/05/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Foundation

extension BinaryFloatingPoint {
   public func rounded(toPlaces places: Int) -> Self {
      guard places >= 0 else { return self }
      let divisor = Self((0..<places).reduce(1.0) { (accum, _) in 10.0 * accum })
      return (self * divisor).rounded() / divisor
   }
}

extension Int: RedBlackTreeRecordProtocol,RedBlackTreeKeyProtocol {
   public typealias RedBlackTreeKey = Int
   
   public static var duplicatesAllowed: Bool { return true }
   public static var duplicatesUseFIFO: Bool { return true }

   public static func ⊰(lhs: Int, rhs: Int) -> RedBlackTreeComparator {
      if lhs < rhs { return .leftTree }
      if lhs == rhs { return .matching }
      return .rightTree
   }

   public var redBlackTreeKey: RedBlackTreeKey { return self }
}

extension Int {
   public func residue(_ n: Int) -> Int {
      if n < 1 { fatalError("Int.residue(_ n:) must have n > 0") }
      var r = self % n
      if r < 0 { r += n }
      return r
   }
}


