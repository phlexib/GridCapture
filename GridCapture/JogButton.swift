//
//  JogButton.swift
//  GridCapture
//
//  Created by ben on 03/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa

class JogButton: NSButton {
    let serialComm : SerialCommunicationController = SerialCommunicationController()

       override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        
    }
    
   
    
    override func mouseDown(theEvent: NSEvent) {
        
            Swift.print("Mous Down")
            serialComm.right()
            super.mouseDown(theEvent)
            Swift.print("mouse Up")
            serialComm.stop()
        
    }
    
    override func mouseUp(theEvent: NSEvent) {
        Swift.print("Mouse UP")
        serialComm.stop()
    }
 
}

