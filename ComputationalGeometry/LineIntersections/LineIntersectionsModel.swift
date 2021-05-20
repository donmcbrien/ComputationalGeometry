//
//  LineIntersectionsModel.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 25/05/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Foundation

class LineIntersectionsModel {
   var queue = RedBlackTree<Event, Vertex>()
   var status = RedBlackTree<LineSegment, CGFloat>()

   var lines = [LineSegment]()
   var vertices = [Vertex]()
   var intersections = [Vertex]()
   var quickIntersections = [Vertex]()
   
   init() { self.reinitialise() }
   
   private func addVertexEvents() {
      for l in lines {
         queue.insert(Event.upper(l))
         queue.insert(Event.lower(l))
      }
   }
}

extension LineIntersectionsModel {
   func run() {
      if let next = queue.minimum { handle(next: next) }
   }
   
   /// Adds a .intersection event to the queue if the line segments intersect
   /// on or below the sweepline and after the current event point.
   ///
   /// When adding an intersection event, it should be joined to any already
   /// existing intersection event at the same point.
   /// - Parameter left: a line segment
   /// - Parameter right: a second line segment
   /// - Returns: void. queue may be mutated
   private func addIntersectionEvent(left: LineSegment, right: LineSegment) {
      guard let v = left.intersects(right) else { return }
      guard v.y <= LineSegment.sweeplineY else { return }
      var set = Set([left,right])
      let events = queue.fetchAll(v).filter { $0.isIntersection() }
      if var event = events.first {
         // event is an intersection so update it
         switch (event) {
         case let .intersection(_,a):
            set.formUnion(a)
            event = Event.intersection(v, set)
         default: break
         }
      } else {
         // new intersection needed
         queue.insert(Event.intersection(v,set))
      }
   }

   private func handle(next event: Event) {
      LineSegment.sweeplineY = event.redBlackTreeKey.y
      // 1. partition segments at this event point into three sets removing them from the status line
      //    check for multiple events and report vertex as intersection
      var uppers = [LineSegment]()
      var lowers = [LineSegment]()
      var intersectors = Set<LineSegment>()
      
      let events = queue.removeAll(event.redBlackTreeKey)
      let multipleEvents = events.count > 1
      
      for e in events {
         switch e {
         case let .upper(segment):
            uppers.append(segment)
         case let .lower(segment):
            lowers.append(segment)
            status.remove(segment.redBlackTreeKey)
         case let .intersection(_,segments):
            intersectors.formUnion(segments)
            for s in segments { status.remove(s.redBlackTreeKey) }
            intersections.append(event.redBlackTreeKey)
         }
      }

      // 2. If multiple events, multiple uppers with or without a single
      //    lower will not have been previously noted as an intersection
      if multipleEvents && (intersectors.count == 0) {
         intersections.append(event.redBlackTreeKey)
      }

      // 3. Shuffle into new order (excluding lowers) and identify horizontals
      var reinserts = Array(intersectors.subtracting(lowers).union(uppers))
      let slanted = reinserts.filter() { $0.rotatedSlope != nil }
      let horizontal = reinserts.filter() { $0.rotatedSlope == nil }
      reinserts = slanted.sorted() { $0.rotatedSlope! < $1.rotatedSlope! }

      // 4. Check for intersections by horizontal upper
      //  for next in status line, do { add intersection } while horiz.intersects(next)
      let neighbours = status.array().filter { $0.sweeplinePosition > event.redBlackTreeKey.x }
      if let h = horizontal.first { // there can only be one!
         for n in neighbours {
            addIntersectionEvent(left: h, right: n)
         }
      }
      
      // 5. Reinsert on the status line and check for new intersections below the sweepline
      for ls in reinserts { status.insert(ls) }
      if reinserts.count > 0 {
         let r = reinserts.first!
         let (left, _) = status.neighboursFor(r.redBlackTreeKey)
         if let left = left { addIntersectionEvent(left: left, right: r) }
         let l = reinserts.last!
         let (_, right) = status.neighboursFor(l.redBlackTreeKey)
         if let right = right  { addIntersectionEvent(left: l, right: right) }
      } else {
         if lowers.count > 0 {
            let (left, right) = status.neighboursFor(lowers.first!.redBlackTreeKey)
            if let left = left, let right = right  { addIntersectionEvent(left: left, right: right) }
         }
      }
   }
}

extension LineIntersectionsModel {
   var minX: Int { return -400 }
   var maxX: Int { return 400 }
   var minY: Int { return -300 }
   var maxY: Int { return 300 }
   var origin:CGPoint { return CGPoint(x: minX - 100, y: minY - 100) }
   
   func getIntersections() {
      quickIntersections = [Vertex]()
      for (l,m) in lines.enumerated() {
         for (k,n) in lines.enumerated() {
            if k > l {
               if let v = m.intersects(n) { quickIntersections.append(v) }
            }
         }
      }
   }
}

extension LineIntersectionsModel {
   private var lineCount: Int { return 200 }
   private var xRange: UInt32 { return UInt32(maxX - minX) }
   private var yRange: UInt32 { return UInt32(maxY - minY) }
   private var lRange: UInt32 { return 50 }
   private var minL: UInt32 { return 50 }

   func reinitialise() {
      queue = RedBlackTree<Event,Vertex>()
      status = RedBlackTree<LineSegment,CGFloat>()
      lines.removeAll()
      vertices.removeAll()
      intersections.removeAll()
      addLines()
      addVertexEvents()
   }

   private func addLines() {
      let xs = [-140,280, 130,  10, -20,  70, 310,  70,  70, -50,  70,130, 340, 370, 370, 190,-110,  20,  70, 310,-250,250]
      let ys = [ 170,-10, 230, -70, 200,  80, 170,  80,  80, -40,  80,-70, 140,  20, 110,  50, 100,-110,  80,  80, -50,-50]
      for i in 1...(xs.count/2) {
         let v1 = Vertex(CGPoint(x:xs[2*i-2],y:ys[2*i-2]))
         let v2 = Vertex(CGPoint(x:xs[2*i-1],y:ys[2*i-1]))
         lines.append(LineSegment(from: v1, to: v2))
         vertices.append(contentsOf: [v1,v2])
      }
//      for _ in 1...lineCount {
//         let x1 = max(min(Int(arc4random_uniform(xRange)) - Int(xRange/2),maxX),minX)
//         let y1 = max(min(Int(arc4random_uniform(yRange)) - Int(yRange/2),maxY),minY)
//         let r = CGFloat(arc4random_uniform(lRange) + minL)
//         let theta = CGFloat(arc4random_uniform(62831)) / 1000.0
//         let x2 = max(min(x1 + Int(r * cos(theta)),maxX),minX)
//         let y2 = max(min(y1 + Int(r * sin(theta)),maxY),minY)
//         let v1 = Vertex(CGPoint(x:x1, y:y1))
//         let v2 = Vertex(CGPoint(x:x2, y:y2))
//         let l = LineSegment(from: v1, to: v2)
//         lines.append(l)
//         vertices.append(contentsOf: [v1,v2])
//      }
   }
}
