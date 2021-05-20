//
//  DCEL.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 11/06/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Foundation

/// DOUBLY-CONNECTED EDGE LIST
///
/// Usage: set up named points thus:
///
/// dcel = DCEL(vertices:["A": CGPoint(x: 0, y: 4)
///                      ,"B": CGPoint(x: 2, y: 4)
///                      ,"C": CGPoint(x: 2, y: 2)
///                      ,"D": CGPoint(x: 1, y: 1)
///                      ,"E": CGPoint(x: 2, y: 0)
///                      ,"F": CGPoint(x: 2, y: 1)
///                      ,"G": CGPoint(x: 1, y: 0)])
///
/// then add faces:
///
/// dcel.addFace("CBAC", boundary: ["C","B","A"], holes: [], attributes: [.Desert,.Forest])
/// dcel.addFace("ABCDCA", boundary: ["A","B","C","D","C"], holes: [["E","G","F"]], attributes: [.Hill])
///
/// dcel is fully set up with named vertices, half-edges and faces

class DCEL {
   var faces = [String:Face]()
   var vertices = [String:Vertex]()
   var halfEdges = [String:HalfEdge]()
   
   //   func facesIncidentTo(face: String) -> [Face] {}
   //   func facesIncidentTo(halfEdge: String) -> [Face] {}
   //   func facesIncidentTo(vertex: String) -> [Face] {}
   //   func verticesIncidentTo(face: String) -> [Vertex] {}
   //   func verticesIncidentTo(halfEdge: String) -> [Vertex] {}
   //   func verticesIncidentTo(vertex: String) -> [Vertex] {}
   func edgesIncidentTo(faceName: String) -> [HalfEdge]? {
      guard let face = faces[faceName] else { return nil }
      var edges = [HalfEdge]()
      var edge = face.anOuterEdge
      repeat {
         edges.append(edge)
         edge = edge.next
      } while edge.name != edges[0].name
      return edges
   }
   //   func edgesIncidentTo(halfEdge: String) -> [HalfEdge] {}
   //   func edgesIncidentTo(vertex: String) -> [HalfEdge] {}
   
   func isolatedVertices() { print( vertices.values.filter() {$0.anIncidentHalfEdge == nil}) }
   
   init(vertices: [String:CGPoint]) {
      for (name,point) in vertices {
         if self.vertices[name] == nil {
            self.vertices[name] = Vertex(name, point)
         }
      }
   }
   
   func addVertices(_ vertices:[String:CGPoint]) {}
   func addFace(_ name:String, boundary:[String], holes:[[String]], attributes:[FaceAttribute]) {
      DCEL.validate(boundary,holes,vertices)
      // process boundary to create edges
      var boundaryEdges = [HalfEdge]()
      for (index,vertex) in boundary.enumerated() {
         let next = (index + 1).residue(boundary.count)
         let newEdge = HalfEdge(vertex+"."+boundary[next], origin: vertices[vertex]!)
         if let twin = halfEdges[boundary[next]+"."+vertex] {
            newEdge.twin = twin
            twin.twin = newEdge
         }
         halfEdges[vertex+"."+boundary[next]] = newEdge
         boundaryEdges.append(newEdge)
      }
      for (index,edge) in boundaryEdges.enumerated() {
         let nextIndex = (index + 1).residue(boundaryEdges.count)
         edge.next = boundaryEdges[nextIndex]
      }
      let anOuterEdge:HalfEdge = boundaryEdges.first!
      // process holes to create edges
      var someInnerEdges = [HalfEdge]()
      for hole in holes {
         var holeEdges = [HalfEdge]()
         var anInnerEdge:HalfEdge?
         for (index,vertex) in hole.enumerated() {
            let next = (index + 1).residue(hole.count)
            let newEdge = HalfEdge(vertex+"."+hole[next], origin: vertices[vertex]!)
            if let twin = halfEdges[hole[next]+"."+vertex] {
               newEdge.twin = twin
               twin.twin = newEdge
            }
            halfEdges[vertex+"."+hole[next]] = newEdge
            holeEdges.append(newEdge)
            anInnerEdge = newEdge   // last edge will be assigned as representative
         }
         for (index,edge) in holeEdges.enumerated() {
            let nextIndex = (index + 1).residue(holeEdges.count)
            edge.next = holeEdges[nextIndex]
         }
         boundaryEdges.append(contentsOf: holeEdges)
         if let anInnerEdge = anInnerEdge { someInnerEdges.append(anInnerEdge) }
      }
      let newFace = Face(name, outerEdge: anOuterEdge, innerHoles: someInnerEdges, attributes: attributes)
      for edge in boundaryEdges {
         edge.incidentFace = newFace
      }
      faces[name] = newFace
   }
   
   static private func validate(_ boundary:[String],_ holes:[[String]],_ vertices:[String:Vertex]) {
      if boundary.count < 3 { fatalError("Error:Must have at least non-collinear vertices on boundary in call to addFace(... boundary: ...)") }
      for vertex in boundary {
         if vertices[vertex] == nil { fatalError("Error:Vertex does not exist in call to addFace(... boundary: ...)") }
      }
      for list in holes {
         for vertex in list {
            if vertices[vertex] == nil { fatalError("Error:Vertex does not exist in call to addFace(... holes: ...)") }
         }
      }
   }
}


