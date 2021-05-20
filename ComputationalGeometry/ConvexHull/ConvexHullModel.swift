//
//  ConvexHullModel.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 25/05/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Foundation

class ConvexHullModel {
   
   var minX: Int = -400
   var maxX: Int = 400
   var minY: Int = -300
   var maxY: Int = 300
   var origin:CGPoint { return CGPoint(x: minX - 100, y: minY - 100) }
   
   var vertices = [Vertex]() // sorted
   var hull = [Vertex]()
   init() {
      addPoints()
      calculateHull()
   }
   
   private func addPoints() {
      for _ in 1...100 {
         let x = Int(arc4random_uniform(UInt32(maxX - minX))) + minX
         let y = Int(arc4random_uniform(UInt32(maxY - minY))) + minY
         vertices.append(Vertex("", CGPoint(x:x,y:y)))
      }
      vertices.sort(by: <)
   }
   
   private func rightTurn(_ list:[Vertex]) -> Bool {
      guard list.count > 2 else { return true }
      var l = list
      let r = l.removeLast()
      let q = l.removeLast()
      let p = l.removeLast()
      let det = ((q.x * r.y) + (p.y * r.x) + (p.x * q.y))
         - ((q.y * r.x) + (p.x * r.y) + (p.y * q.x))
      return det < 0
   }
   
   private func calculateHull() {
      var upper = [Vertex]()
      upper.append(vertices[0])
      upper.append(vertices[1])
      for i in 2..<vertices.count {
         upper.append(vertices[i])
         while !rightTurn(upper) {
            upper.remove(at: upper.count - 2)
         }
      }
      var lower = [Vertex]()
      lower.append(vertices[vertices.count - 1])
      lower.append(vertices[vertices.count - 2])
      for i in (0..<(vertices.count - 2)).reversed() {
         lower.append(vertices[i])
         while !rightTurn(lower) {
            lower.remove(at: lower.count - 2)
         }
      }
      lower.removeLast()
      lower.removeFirst()
      upper.append(contentsOf: lower)
      hull = upper
   }
}
