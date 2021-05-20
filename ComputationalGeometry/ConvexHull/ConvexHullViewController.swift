//
//  ConvexHullViewController.swift
//  ComputationalGeometry
//
//  Created by Don McBrien on 25/05/2019.
//  Copyright © 2019 Don McBrien. All rights reserved.
//

import Cocoa

class ConvexHullViewController: NSViewController, ConvexHullGraphViewDelegate {
   
   @IBOutlet weak var convexHullView: ConvexHullView!
   var model = ConvexHullModel()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      convexHullView.wantsLayer = true
      convexHullView.layer?.backgroundColor = NSColor.white.cgColor
      
      convexHullView.delegate = self
      convexHullView.bounds.origin = model.origin
   }
}
