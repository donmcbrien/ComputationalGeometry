//
//  ConvexHullView.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 25/05/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Cocoa

protocol ConvexHullGraphViewDelegate {
   var model: ConvexHullModel {get }
}

class ConvexHullView: CartesianGridView {
   var delegate: ConvexHullGraphViewDelegate!

   override var plusX:Int { return delegate.model.maxX + 50 }
   override var minusX:Int { return  delegate.model.minX - 50 }
   override public var plusY: Int {  return delegate.model.maxY + 50 }
   override public var minusY: Int {  return delegate.model.minY - 50 }
   override public var majorInterval: Int { return 100 }

   override func draw(_ dirtyRect: NSRect) {
      super.draw(dirtyRect)
      
      for dot in delegate.model.vertices {
         let radius:CGFloat = 2
         let diameter:CGFloat = radius * 2
         let dotPath = NSBezierPath(ovalIn: NSMakeRect(dot.x-radius, dot.y-radius, diameter, diameter))

         NSColor.blue.setFill()
         NSColor.red.setStroke()
         dotPath.lineWidth = 1
         dotPath.fill()
      }

      let path = NSBezierPath()
      var hull = delegate.model.hull
      path.move(to: hull.removeFirst().coordinates)
      while hull.count > 0 {
         path.line(to: hull.removeFirst().coordinates)
      }
      path.close()
      path.stroke()
   }
   
}
