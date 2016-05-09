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
    var columns = 10
    var rows = 10
    
    
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
        
        drawGrid()
        drawCamera()
    }
    
    
    func drawGrid(){
        for i in 1...columns {
            
            let floatVertical = self.frame.height / CGFloat(columns) * CGFloat(i)
            let startPointVertical : CGPoint = CGPointMake(0, floatVertical)
            let endPointVertical : CGPoint = CGPointMake(self.frame.width, floatVertical)
      
            let lineVertical = NSBezierPath()
            lineVertical.moveToPoint(startPointVertical)
            lineVertical.lineToPoint(endPointVertical)
            lineVertical.lineWidth = 0.5
            lineVertical.stroke()
            
                   }
        
        for i in 1...rows{
            
            let floatHorizontal = self.frame.width / CGFloat(rows) * CGFloat(i)
            let startPointHorizontal : CGPoint = CGPointMake(floatHorizontal, 0)
            let endPointHorizontal : CGPoint = CGPointMake(floatHorizontal, self.frame.height)
            
            let lineHorizontal = NSBezierPath()
            lineHorizontal.moveToPoint(startPointHorizontal)
            lineHorizontal.lineToPoint(endPointHorizontal)
            lineHorizontal.lineWidth = 0.5
            lineHorizontal.stroke()

        }

    }
    
    // CAMERA POSITION
    func drawCamera(){
        
       
        let width : CGFloat = CGFloat(10)
        let height : CGFloat = CGFloat(10)
        let centerX = (cameraPosition.x-(width/2))
        let centerY = (cameraPosition.y-(height/2))
        
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
