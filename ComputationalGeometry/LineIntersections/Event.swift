//
//  Event.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 25/05/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Foundation

enum Event {
   case upper(LineSegment)
   case lower(LineSegment)
   case intersection(Vertex,Set<LineSegment>)

   func isIntersection() -> Bool {
      switch self {
      case .intersection(_, _): return true
      default: return false
      }
   }
}

extension Event: RedBlackTreeRecordProtocol {
   public var redBlackTreeKey: Vertex {
      switch self {
      case .upper(let line): return line.upper
      case .lower(let line): return line.lower
      case .intersection(let point, _): return point
      }
   }
}

extension Event: CustomStringConvertible {
   var description: String {
      switch self {
      case let .upper(l):
         return "upper(\(l))"
      case let .lower(l):
         return "lower(\(l))"
      case let .intersection(v,a):
         return "intersection(\(v)|\(a.count))"
      }
   }
}

