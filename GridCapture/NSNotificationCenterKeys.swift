//
//  NSNotificationCenterKeys.swift
//  GridCapture
//
//  Created by ben on 02/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//
////// Simple Class to Easy access Notification Keys

import Cocoa

class NSNotificationCenterKeys: NSObject {
    
    
    // Keys for All notifications
    
    let cameraPositionKey = "cameraPositionKey"
    let homeKey = "homeKey"
    let startKey = "startKey"
    let endKey = "endKey"
    let recordKey = "recordKey"
    let pictureKey = "pictureKey"
    let frameKey = "frameKey"
    let rigIsConnected = "rigIsConnected"
    let rigIsDisconnected = "rigIsDisconnected"
    let gridSettings = "gridSettings"
    let setUpGrid = "setUpGrid"
    let moveTo = "moveTo"
    let arduinoCallback = "arduinoCallback"
    
        
    // MARK : parse Data to assign X and Y
    
    func parseDataPosition(incomeString : String)-> (Int,Int){
        
        let splitString = incomeString.componentsSeparatedByString(",")
        var position = (x:0,y:0)
        if splitString.count > 0 {
            let xPosition = splitString[0]
            let yPosition = splitString[1]
            let intXPosition : Int = Int (xPosition)!
            let intYPosition :Int = Int(yPosition)!
            position = (x:intXPosition,y: intYPosition)
            

        }else{
            position = (x:0,y:0)
        }
        return position
}
}