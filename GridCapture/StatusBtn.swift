//
//  StatusBtn.swift
//  Grid Capture
//
//  Created by ben on 30/04/2016.
//  Copyright © 2016 Park Bench. All rights reserved.
//

import Cocoa

@IBDesignable

class StatusBtn: NSView {
    
    var statusBtnColor = StyleKit.off

    
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        let statusBtn = NSBezierPath(roundedRect: NSMakeRect(0, 0, 10, 10), xRadius: 10, yRadius: 10)
        statusBtnColor.setFill()
        statusBtn.fill()
    }
    
}

