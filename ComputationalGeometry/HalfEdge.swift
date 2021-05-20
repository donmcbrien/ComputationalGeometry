//
//  HalfEdge.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 19/06/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Foundation

class HalfEdge: CustomStringConvertible {
   var name: String
   let origin: Vertex
   var twin: HalfEdge?
   var incidentFace: Face!
   var next: HalfEdge!
   var previous: HalfEdge? { return twin?.next }
   
   init(_ name: String, origin: Vertex) {
      self.name = name
      self.origin = origin
      origin.setIncident(halfEdge: self)
   }
   
   func makeTwin(_ name: String, atOrigin: Vertex) -> HalfEdge {
      let t = HalfEdge(name, origin: atOrigin)
      t.twin = self
      self.twin = t
      return t
   }
   
   func setIncident(face: Face) {
      self.incidentFace = face
   }
   
   func isReadyForUse() ->Bool {
      return twin != nil && incidentFace != nil && next != nil
   }
   
   public var description: String {
      if isReadyForUse() {
         return "\(name) HalfEdge from \(origin.name), twin: \(twin!.name), face: \(incidentFace.name), next: \(next.name)"
      }
      else {
         var str = "\(name) HalfEdge from \(origin.name)"
         if twin != nil { str = str + ", twin: \(twin!.name)" }
         if incidentFace != nil { str = str + ", face: \(incidentFace.name)" }
         if next != nil { str = str + ", next: \(next.name)" }
         str = str + ", not ready for use"
         return str
      }
   }
}
