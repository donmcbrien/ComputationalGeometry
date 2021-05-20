//
//  CartesianGridView.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 29/05/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Cocoa

class CartesianGridView: NSView {

   // Standard dimensions, override as required
   var plusX: Int { return 500 }
   var minusX: Int { return -plusX }
   var plusY: Int { return 400 }
   var minusY: Int { return -plusY }
   var majorInterval: Int { return 100 }
   var minorInterval: Int { return 25 }

   func drawGrid() {
      let grid = NSBezierPath()
      for y in stride(from: 0, to: minusY, by: -majorInterval) {
         grid.move(to: NSPoint(x: minusX, y: y))
         grid.line(to: NSPoint(x: plusX, y: y))
         for x in stride(from: 0, to: minusX, by: -minorInterval) {
            grid.move(to: NSPoint(x: x, y: y - 3))
            grid.line(to: NSPoint(x: x, y: y + 3))
         }
         for x in stride(from: 0, to: plusX, by: minorInterval) {
            grid.move(to: NSPoint(x: x, y: y - 3))
            grid.line(to: NSPoint(x: x, y: y + 3))
         }
      }
      for y in stride(from: 0, to: plusY, by: majorInterval) {
         grid.move(to: NSPoint(x: minusX, y: y))
         grid.line(to: NSPoint(x: plusX, y: y))
         for x in stride(from: 0, to: minusX, by: -minorInterval) {
            grid.move(to: NSPoint(x: x, y: y - 3))
            grid.line(to: NSPoint(x: x, y: y + 3))
         }
         for x in stride(from: 0, to: plusX, by: minorInterval) {
            grid.move(to: NSPoint(x: x, y: y - 3))
            grid.line(to: NSPoint(x: x, y: y + 3))
         }
      }
      for x in stride(from: 0, to: minusX, by: -majorInterval) {
         grid.move(to: NSPoint(x: x, y: minusY))
         grid.line(to: NSPoint(x: x, y: plusY))
         for y in stride(from: 0, to: minusY, by: -minorInterval) {
            grid.move(to: NSPoint(x: x - 3, y: y))
            grid.line(to: NSPoint(x: x + 3, y: y))
         }
         for y in stride(from: 0, to: plusY, by: minorInterval) {
            grid.move(to: NSPoint(x: x - 3, y: y))
            grid.line(to: NSPoint(x: x + 3, y: y))
         }
      }
      for x in stride(from: 0, to: plusX, by: majorInterval) {
         grid.move(to: NSPoint(x: x, y: minusY))
         grid.line(to: NSPoint(x: x, y: plusY))
         for y in stride(from: 0, to: minusY, by: -minorInterval) {
            grid.move(to: NSPoint(x: x - 3, y: y))
            grid.line(to: NSPoint(x: x + 3, y: y))
         }
         for y in stride(from: 0, to: plusY, by: minorInterval) {
            grid.move(to: NSPoint(x: x - 3, y: y))
            grid.line(to: NSPoint(x: x + 3, y: y))
         }
      }
      grid.lineWidth = 1
      NSColor.lightGray.setStroke()
      grid.stroke()
   }
   func drawAxes() {
      let axes = NSBezierPath()
      axes.move(to: NSPoint(x: minusX, y: 0))
      axes.line(to: NSPoint(x: plusX, y: 0))
      axes.move(to: NSPoint(x: 0, y: minusY))
      axes.line(to: NSPoint(x: 0, y: plusY))
      axes.lineWidth = 1
      NSColor.red.setStroke()
      axes.stroke()
   }
   
   func drawOutline() {
      let border = NSBezierPath()
      border.move(to: NSPoint(x: minusX, y: minusY))
      border.line(to: NSPoint(x: minusX, y: plusY))
      border.line(to: NSPoint(x: plusX, y: plusY))
      border.line(to: NSPoint(x: plusX, y: minusY))
      border.close()
      border.lineWidth = 3
      NSColor.black.setStroke()
      border.stroke()
   }
   
   override func draw(_ dirtyRect: NSRect) {
      super.draw(dirtyRect)
      
      drawGrid()
      drawAxes()
      drawOutline()
   }
}
