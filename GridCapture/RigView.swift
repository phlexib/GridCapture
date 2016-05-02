//
//  RigView.swift
//  GridCapture
//
//  Created by ben on 02/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa

class RigView: NSView {

    var cameraPosition : CGPoint = CGPointMake(0,0)
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        self.wantsLayer = true
        self.layer?.backgroundColor = StyleKit.rightMenu.CGColor
        
        // draw Rectangle
        
        let boxColor = StyleKit.oval15Copy3
        let separatorColor = StyleKit.separator
        
        let rectangleGrid = NSBezierPath(rect: NSMakeRect(0.0, 0.0, self.frame.width, self.frame.height))
        
        boxColor.setFill()
        rectangleGrid.fill()
        separatorColor.setStroke()
        rectangleGrid.lineWidth = 2.0
        rectangleGrid.stroke()
        
        // draw lines
        for i in 1...10 {
        
        let floatVertical = self.frame.height / CGFloat(10) * CGFloat(i)
        let startPointVertical : CGPoint = CGPointMake(0, floatVertical)
        let endPointVertical : CGPoint = CGPointMake(self.frame.width, floatVertical)
            
            let floatHorizontal = self.frame.width / CGFloat(10) * CGFloat(i)
            let startPointHorizontal : CGPoint = CGPointMake(floatHorizontal, 0)
            let endPointHorizontal : CGPoint = CGPointMake(floatHorizontal, self.frame.height)
        
            
            
        let lineVertical = NSBezierPath()
        lineVertical.moveToPoint(startPointVertical)
        lineVertical.lineToPoint(endPointVertical)
        lineVertical.lineWidth = 0.5
        lineVertical.stroke()
            
            let lineHorizontal = NSBezierPath()
            lineHorizontal.moveToPoint(startPointHorizontal)
            lineHorizontal.lineToPoint(endPointHorizontal)
            lineHorizontal.lineWidth = 0.5
            lineHorizontal.stroke()
            
        
            // draw Camera Position
            cameraPosition = CGPointMake(self.frame.width / 2, self.frame.height / 2)
            let width : CGFloat = CGFloat(20);
            let height : CGFloat = CGFloat(20);
            let centerX = cameraPosition.x - width/2;
            let centerY = cameraPosition.y - height/2;
        
        let cameraCircle = NSBezierPath(ovalInRect: CGRectMake(centerX,centerY, width, height))
        let cameraColor = NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
        cameraColor.setFill()
        cameraCircle.fill()
        let cameraContour = NSColor.whiteColor()
        cameraCircle.lineWidth = 1
        cameraContour.setStroke()
        cameraCircle.stroke()
        }
    }
    
}
