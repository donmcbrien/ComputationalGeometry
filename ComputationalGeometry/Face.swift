//
//  Face.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 22/08/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Foundation

enum FaceAttribute:String {
   case Forest
   case Hill
   case Lake
   case Desert
   case Mountain
   case Plain
}

class Face: CustomStringConvertible {
   var name: String
   let anOuterEdge: HalfEdge          // outerComponent, nil if unbounded
   var someInnerEdges: [HalfEdge]   // innerComponent, empty if no holes
   let attributes: [FaceAttribute]
   
   init(_ name: String, outerEdge: HalfEdge, innerHoles: [HalfEdge], attributes:[FaceAttribute]) {
      self.name = name
      self.attributes = attributes
      self.anOuterEdge = outerEdge
      self.someInnerEdges = innerHoles
   }
   
   public var description: String {
      return "\(name) starting at \(anOuterEdge.name), inner: \(someInnerEdges.map {$0.name}), \(attributes.map { $0.rawValue })"
      
   }
}
