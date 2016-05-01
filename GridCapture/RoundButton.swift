//
//  RoundButton.swift
//  Grid Capture
//
//  Created by ben on 29/04/2016.
//  Copyright © 2016 Park Bench. All rights reserved.
//

import Cocoa

class RoundButton: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        
        let roundButton = NSBezierPath(roundedRect: NSMakeRect(0, 0, 180, 20), xRadius: 10, yRadius: 10)
        StyleKit.bgBar.setFill()
        roundButton.fill()
    }
    
}
