//
//  SweeplineView.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 25/05/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Cocoa

class SweeplineView: CartesianGridView {
   
   static var sweepY: CGFloat = 0.0 // will be set by model
   let dashPattern: [CGFloat] = [6.0, 3.0]
   
   func drawSweeplineY() {
      let sweepline = NSBezierPath()
      sweepline.move(to: NSPoint(x: CGFloat(minusX), y: SweeplineView.sweepY))
      sweepline.line(to: NSPoint(x: CGFloat(plusX), y: SweeplineView.sweepY))
      sweepline.lineWidth = 1
      NSColor.purple.setStroke()
      sweepline.setLineDash(dashPattern, count: 2, phase: 0.0)
      sweepline.stroke()
   }
   
   override func draw(_ dirtyRect: NSRect) {
      super.draw(dirtyRect)
      
      drawSweeplineY()
   }
}
