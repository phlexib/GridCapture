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
    let home = "home"
    let start = "star"
    let end = "end"
    let record = "record"
    let picture = "picture"
    let frame = "frame"
    let rigIsConnected = "rigIsConnected"
    let rigIsDisconnected = "rigIsDisconnected"
    let gridSettings = "gridSettings"
    let setUpGrid = "setUpGrid"
    let moveTo = "moveTo"
    let arduinoCallback = "arduinoCallback"
    let arrivedAtTarget = "arrivedAtTarget"
    let pictureDone = "pictureDone"
        
    // MARK : parse Data to assign X and Y
    
    func parseDataPosition(incomeString : String)-> (x:Int,y:Int){
        
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