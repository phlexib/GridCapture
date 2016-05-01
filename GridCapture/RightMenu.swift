//
//  RightMenu.swift
//  Grid Capture
//
//  Created by ben on 29/04/2016.
//  Copyright © 2016 Park Bench. All rights reserved.
//

import Cocoa

@IBDesignable

class RightMenu: NSView {

    
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        self.wantsLayer = true
        self.layer?.backgroundColor = StyleKit.rightMenu.CGColor
        
        
        //// Rectangle
        
        let rectangleGrid = NSBezierPath(rect: NSMakeRect(0.0, self.frame.height-118.0, self.frame.width, 40))
        let rectangleCamera = NSBezierPath(rect: NSMakeRect(0.0, self.frame.height-360, self.frame.width, 40))
        let boxColor = StyleKit.bgBar
        let separatorColor = StyleKit.separator
        
        boxColor.setFill()
        separatorColor.setStroke()
        rectangleGrid.fill()
        rectangleGrid.stroke()
        rectangleCamera.fill()
        rectangleCamera.stroke()
        
        
        // Separator
        let lineTwo = NSBezierPath()
        lineTwo.moveToPoint(NSMakePoint(0.0, self.frame.height-148))
        lineTwo.lineToPoint(NSMakePoint(self.frame.width, self.frame.height-148))
        
        let lineThree = NSBezierPath()
        lineThree.moveToPoint(NSMakePoint(0.0, self.frame.height-178))
        lineThree.lineToPoint(NSMakePoint(self.frame.width, self.frame.height-178))
        
        let lineFour = NSBezierPath()
        lineFour.moveToPoint(NSMakePoint(0.0, self.frame.height-208))
        lineFour.lineToPoint(NSMakePoint(self.frame.width, self.frame.height-208))
        
        
        let bezierPath = NSBezierPath()
        bezierPath.moveToPoint(NSMakePoint(0.0, 0.0))
        bezierPath.lineToPoint(NSMakePoint(0.0, self.frame.height - 78))
        separatorColor.setStroke()
        
        bezierPath.lineWidth = 0.5
        bezierPath.stroke()
        lineTwo.lineWidth = 0.5
        lineTwo.stroke()
        lineThree.lineWidth = 0.5
        lineThree.stroke()
        lineFour.lineWidth = 0.5
        lineFour.stroke()
        
        

    }
    
}
