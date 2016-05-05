//
//  CustomProgressIndicator.swift
//  GridCapture
//
//  Created by ben on 05/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa

class CustomProgressIndicator: NSProgressIndicator {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        self.wantsLayer = true
            }
    
    
    
       
}
