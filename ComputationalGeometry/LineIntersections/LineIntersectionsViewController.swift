//
//  LineIntersectionsViewController.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 25/05/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Cocoa

class LineIntersectionsViewController: NSViewController, LineIntersectionsGraphViewDelegate {
   
   @IBOutlet weak var lineIntersectionsView: LineIntersectionsView!
   var model = LineIntersectionsModel()
   
   @IBAction func setup(_ sender: NSButton) {
      model.reinitialise()
      lineIntersectionsView.setNeedsDisplay(lineIntersectionsView.bounds)
   }
   
   @IBAction func report(_ sender: NSButton) {
      print(model.intersections.count)
      print(model.intersections.sorted() { $0.x < $1.x } )
      let iSet = Set(model.intersections)
      model.getIntersections()
      print(model.quickIntersections.count)
      print(model.quickIntersections.sorted() { $0.x < $1.x } )
      let qSet = Set(model.quickIntersections)
      let d1Set = iSet.subtracting(qSet)
      let d2Set = qSet.subtracting(iSet)
      print(iSet.count,qSet.count,d1Set.count,d2Set.count,d1Set,d2Set)
   }
   
   @IBAction func run(_ sender: NSButton) {
      DispatchQueue.main.async {
         if self.runModel() {
            self.run(sender)
         }
      }
   }

   @IBAction func slowly(_ sender: NSButton) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
         if self.runModel() {
            self.slowly(sender)
         }
      })
   }

   private func runModel() -> Bool {
      self.model.run()
      self.lineIntersectionsView.setNeedsDisplay(self.lineIntersectionsView.bounds)
      return self.model.queue.count > 0
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()

      lineIntersectionsView.wantsLayer = true
      lineIntersectionsView.layer?.backgroundColor = NSColor.white.cgColor
      
      lineIntersectionsView.delegate = self
      // Do view setup here.
      lineIntersectionsView.bounds.origin = model.origin
   }
}


