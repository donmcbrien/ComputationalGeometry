//
//  LineSegment.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 25/05/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Foundation
import RedBlackTree

enum Network {
   case blue
   case red
}

enum Intersection {
   case none
   case point(Vertex)
   case segment(LineSegment)
}

class LineSegment {
   static var sweeplineY: CGFloat = 0.0 {// set before asking for sequencer
      didSet { SweeplineView.sweepY = sweeplineY }
   }
   let name: String
   private let firstHalf: HalfEdge
   private let secondHalf: HalfEdge
   private var origin: Vertex { return firstHalf.origin }
   private var end: Vertex { return secondHalf.origin }

   var upper: Vertex { return (origin ⊰ end) == .leftTree ? origin : end }
   var lower: Vertex { return (origin ⊰ end) == .leftTree ? end : origin }
   var network: Network
   
   var sweeplinePosition: CGFloat {
      // the x value on the line segment when y = LineSegment.sweepLine
      if end.y == origin.y { return origin.x }  // horizontal line
      return ((LineSegment.sweeplineY - origin.y) * (end.x - origin.x) / (end.y - origin.y) + origin.x).rounded(toPlaces: 3)
   }
   
   var rotatedSlope: CGFloat? {
      // used to sort points at an intersection
      // this is the slope of the line segment
      // after rotation through 90 degrees anti-clockwise
      if origin.y == end.y { return nil }  // horizontal line
      return (end.x - origin.x) / (origin.y - end.y)
   }
   
   init(from: Vertex, to: Vertex, net: Network = .blue) {
      if from == to { fatalError("error: in LineSegment:init(id:,from:, to:), from == to ")}
      self.name = from.name + ">>" + to.name
      firstHalf = HalfEdge(from.name + ">>" + to.name, origin: from)
      secondHalf = firstHalf.makeTwin(to.name + ">>" + from.name, atOrigin: to)
      network = net
   }
   
   func intersects(_ line: LineSegment) -> Vertex? {
      let ax = origin.x
      let ay = origin.y
      
      let ux = end.x-ax
      let uy = end.y-ay
      
      let cx = line.origin.x
      let cy = line.origin.y
      
      let vx = line.end.x-cx
      let vy = line.end.y-cy
      
      if (vx * uy) == (vy * ux) { return nil }  // parallel or overlapping
      
      let s = (ux * (ay - cy) + uy * (cx - ax)) / (ux * vy - uy * vx)
      let t = (vx * (ay - cy) + vy * (cx - ax)) / (ux * vy - uy * vx)
      
      if t < 0 || t > 1.0 || s < 0.0 || s > 1.0 { return nil }  // intersects beyond segments
      let p = Vertex(CGPoint(x: ax + t * ux, y: ay + t * uy))
      return p
   }
   
//   func intersects(_ line: LineSegment) -> Intersection {
//      let ax = origin.x
//      let ay = origin.y
//      
//      let ux = end.x-ax
//      let uy = end.y-ay
//      
//      let cx = line.origin.x
//      let cy = line.origin.y
//      
//      let vx = line.end.x-cx
//      let vy = line.end.y-cy
//      
//      if (vx * uy) == (vy * ux) { return self.overlaps(with: line) }  // parallel or overlapping
//      
//      let s = (ux * (ay - cy) + uy * (cx - ax)) / (ux * vy - uy * vx)
//      let t = (vx * (ay - cy) + vy * (cx - ax)) / (ux * vy - uy * vx)
//      
//      if t < 0 || t > 1.0 || s < 0.0 || s > 1.0 { return Intersection.none }  // intersects beyond segments
//      let p = Vertex(CGPoint(x: ax + t * ux, y: ay + t * uy))
//      return Intersection.point(p)
//   }
//
//   private func overlaps(with line: LineSegment) -> Intersection {
//      return Intersection.segment(LineSegment(from: <#T##Vertex#>, to: <#T##Vertex#>))
//   }
}

extension LineSegment: Equatable, Hashable {
   func hash(into hasher: inout Hasher) {
      hasher.combine(upper)
      hasher.combine(lower)
   }
   
   static func == (lhs: LineSegment, rhs: LineSegment) -> Bool {
      return lhs.origin == rhs.origin && lhs.end == rhs.end
   }
}

extension LineSegment: RedBlackTreeRecordProtocol {
   typealias RedBlackTreeKey = CGFloat

   public var redBlackTreeKey: RedBlackTreeKey { return sweeplinePosition }
}

extension LineSegment: CustomStringConvertible {
   var description: String {
      //return "\(id)|\(sequencer)"
      return "LineSegment: \(firstHalf.name)"
   }
}

extension CGFloat: RedBlackTreeKeyProtocol {
   public static func ⊰ (lhs: CGFloat, rhs: CGFloat) -> RedBlackTreeComparator {
      if lhs < rhs { return .leftTree }
      if lhs > rhs { return .rightTree }
      return .matching
   }
   
   public static var duplicatesAllowed: Bool { return true }
   public static var duplicatesUseFIFO: Bool { return true }
}
