//
//  Vertex.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 25/05/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Foundation
import RedBlackTree

public class Vertex {
   var name: String
   var anIncidentHalfEdge: HalfEdge!
   public var x: CGFloat { return coordinates.x }
   public var y: CGFloat { return coordinates.y }
   
   var coordinates: CGPoint

   public init(_ name: String, _ coordinates: CGPoint) {
      self.name = name
      self.coordinates = coordinates
   }

   public init(_ coordinates: CGPoint) {
      self.name = String(format: "(%.3f, %.3f)", coordinates.x, coordinates.y)
      self.coordinates = coordinates
   }
}

extension Vertex: CustomStringConvertible {
   func setIncident(halfEdge: HalfEdge) {
      self.anIncidentHalfEdge = halfEdge
   }
   
   public var description: String {
      var str = String(format: "\(name) Vertex: (%.3f, %.3f )", coordinates.x, coordinates.y)
      if anIncidentHalfEdge == nil { str += "isolated vertex" }
      else { str += "with incident edge: \(anIncidentHalfEdge.name)" }
      return str
   }
}

extension Vertex: Comparable, Hashable {
   public func hash(into hasher: inout Hasher) {
      hasher.combine(x)
      hasher.combine(y)
   }
   
   public static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
      return (Int(lhs.x * 1000) - Int(rhs.x * 1000)) == 0 &&
         (Int(lhs.y * 1000) - Int(rhs.y * 1000)) == 0
//      return (lhs.x == rhs.x) && (lhs.y == rhs.y)
   }
   
   public static func < (lhs: Vertex, rhs: Vertex) -> Bool {
      return lhs.x < rhs.x || (lhs.x == rhs.x && lhs.y <= rhs.y)
   }
}

extension Vertex: RedBlackTreeKeyProtocol {
   public static var duplicatesAllowed: Bool { return true }
   public static var duplicatesUseFIFO: Bool { return false }

   public static func ⊰(lhs: Vertex, rhs: Vertex) -> RedBlackTreeComparator {
      if lhs.y > rhs.y { return .leftTree }
      if lhs.y == rhs.y && lhs.x < rhs.x { return .leftTree }
      if lhs.y == rhs.y && lhs.x == rhs.x { return .matching }
      // For all other cases, i.e.
      // (lhs.y == rhs.y && lhs.x > rhs.x)
      // or lhs.y < rhs.y
      return .rightTree
   }
}
