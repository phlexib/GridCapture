//
//  LeftMenu.swift
//  Grid Capture
//
//  Created by ben on 29/04/2016.
//  Copyright © 2016 Park Bench. All rights reserved.
//

import Cocoa


@IBDesignable

class LeftMenu: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        self.wantsLayer = true
        self.layer?.backgroundColor = StyleKit.leftMenu.CGColor
        
        
        let boxColor = StyleKit.bgBar
        let separatorColor = StyleKit.separator
        
        let rectangleGrid = NSBezierPath(rect: NSMakeRect(0.0, self.frame.height-118.0, self.frame.width, 40))
        
        
        
        boxColor.setFill()
        rectangleGrid.fill()
        separatorColor.setStroke()
        rectangleGrid.stroke()
        
        
        let rectangleRig = NSBezierPath(rect: NSMakeRect(0.0, 240, self.frame.width, 40))
        boxColor.setFill()
        separatorColor.setStroke()
        rectangleRig.fill()
        rectangleRig.stroke()
        
        
        let bezierPath = NSBezierPath()
        
        bezierPath.moveToPoint(NSMakePoint(self.frame.width, 0.0))
        bezierPath.lineToPoint(NSMakePoint(self.frame.width, self.frame.height))
        
        separatorColor.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.stroke()
        
        
    }
    
}
