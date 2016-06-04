//
//  ScanObject.swift
//  GridCapture
//
//  Created by ben on 23/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa

class ScanObject: NSObject {

     var camera = CameraObject()
    
    // source properties
    var subjectSizeInch = (width:40.0, height : 30.0)
    var subjectSize : (width:Double,height:Double){
        get{
            return (width:subjectSizeInch.width * 25.4, height:subjectSizeInch.height * 25.4)
        }
    }
    
    // print variables
    let name = String()
    let printSize = (width:60.0,height:38.0)
    var printResolution = 300.0
    var overlap = 1.2
    
    
    
    
    // computed properties
    var  widthPixelsNeeded : Double{
        get{
            return printSize.width * printResolution
        }
    }
    
    var  heightPixelsNeeded : Double{
        get{
            return printSize.height * printResolution
        }
    }
    
    var wSlicesFromPixels : Double{
        get{
            return ceil((widthPixelsNeeded / camera.resolution.wPixels) * overlap)
        }
    }
    
    var hSlicesFromPixels : Double{
        get{
            return ceil((heightPixelsNeeded / camera.resolution.hPixels) * overlap)
        }
    }
    
    var wFovNeeded : Double{
        get{
            return subjectSize.width / wSlicesFromPixels
        }
    }
    
    var hFovNeeded : Double{
        get{
            return subjectSize.height / hSlicesFromPixels
        }
    }
   
    var wDistanceNeeded : Double {
        get{
            return (camera.focalLength  / (camera.sensorMm.widthMM / wFovNeeded))
        }
    }
    
    var hDistanceNeeded : Double {
        get{
            return (camera.focalLength  / (camera.sensorMm.heightMM / hFovNeeded))
        }
    }
    
    var distanceNeeded : Double{
        get{
            if wDistanceNeeded >= hDistanceNeeded{
                return round(wDistanceNeeded)
            }
            else {
                return round(hDistanceNeeded)
            }

        }
    }
    
    override var  description : String{
        get{
            return "For a print of \(printSize) inches and a focal length of \(camera.focalLength), you need to set the camera at \(distanceNeeded) and take \(wSlicesFromPixels) horizontally and \(hSlicesFromPixels) vertically."

        }
    }
}