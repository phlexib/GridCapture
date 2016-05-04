//
//  CircleView.swift
//  GridCapture
//
//  Created by ben on 03/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa

class CircleView: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // draw Camera Position
        let cameraPosition = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        let width : CGFloat = CGFloat(10);
        let height : CGFloat = CGFloat(10);
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
