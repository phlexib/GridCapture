//
//  CustomSegmentedControl.swift
//  GridCapture
//
//  Created by ben on 02/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa

class CustomSegmentedControl: NSSegmentedControl {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        setLabel("Rig", forSegment: 0)
        setLabel("Grid", forSegment: 1)
        setLabel("Image", forSegment: 2)
    }
    
   }

