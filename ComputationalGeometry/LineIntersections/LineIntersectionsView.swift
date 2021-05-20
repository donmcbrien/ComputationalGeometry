//
//  LineIntersectionsView.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 25/05/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Cocoa

protocol LineIntersectionsGraphViewDelegate {
   var model: LineIntersectionsModel { get }
}

class LineIntersectionsView: SweeplineView {
   
   var delegate: LineIntersectionsGraphViewDelegate!

   let vertexColour = NSColor.blue
   let intersectColour = NSColor.red
   let lineColour = NSColor.green

   let lineWidth: CGFloat = 1.0
   let dotDiameter: CGFloat = 4.0
   var dotRadius: CGFloat { return dotDiameter / 2 }

   override var plusX:Int { return delegate.model.maxX + 50 }
   override var minusX:Int { return  delegate.model.minX - 50 }
   override public var plusY: Int {  return delegate.model.maxY + 50 }
   override public var minusY: Int {  return delegate.model.minY - 50 }
   override public var majorInterval: Int { return 100 }
   
   private func convert(_ vertex: Vertex) -> NSPoint {
      return NSPoint(x: vertex.x, y: vertex.y)
   }

   private func drawPoints(array:[Vertex], colour: NSColor) {
      for point in array {
         let dot = NSBezierPath(ovalIn: NSMakeRect(point.x - dotRadius,
                                                   point.y - dotRadius,
                                                   dotDiameter,
                                                   dotDiameter))
         colour.setFill()
         dot.lineWidth = lineWidth
         dot.fill()
      }
   }

   private func drawLines(array:[LineSegment], colour: NSColor) {
      for segment in array {
         let line = NSBezierPath()
         line.move(to: convert(segment.lower))
         line.line(to: convert(segment.upper))
         colour.setStroke()
         line.lineWidth = lineWidth
         line.stroke()
      }
   }

   private func drawLineSegments() {
      drawLines(array: delegate.model.lines, colour: lineColour)
   }

   private func drawIntersections() {
      drawPoints(array: Array(delegate.model.intersections), colour: intersectColour)
   }

   private func drawVertices() {
      drawPoints(array: delegate.model.vertices, colour: vertexColour)
   }
   
   override func draw(_ dirtyRect: NSRect) {
      super.draw(dirtyRect)

      drawLineSegments()
      drawVertices()
      drawIntersections()
   }
}
