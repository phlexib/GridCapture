//
//  CameraObject.swift
//  GridCapture
//
//  Created by ben on 05/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa

class CameraObject: NSObject {
    
    // camera properties
    let brand = String()
    let model = String()
    var distance = Double()
    var focalLength = Double()
    var exposure = Double()
    var aperture = Float()
    var wb = String()
    var iso = Int()
    var sensorMm = (widthMM:36.0,heightMM:24.0)
    var resolution = (wPixels:5616.0,hPixels:3744.0)
    
    // computed properties
    var sensorDiagonal : Double {
        get{
            return sqrt(pow(sensorMm.widthMM,2) + pow(sensorMm.heightMM,2))
        }
    }
    
    var hFov : Double{
        get{
           return sensorMm.widthMM / (focalLength  / distance)
        }
    }
    
    var vFov : Double{
        get{
            return sensorMm.heightMM / (focalLength / distance )
        }
    }
    
    var hDegrees : Double{
        let deg = 2 * atan((sensorMm.widthMM) / (2 * focalLength))
        return round(toDegrees(deg) * 10) / 10
    }
    
    var vDegrees : Double{
        get{
            let deg = 2 * atan((sensorMm.heightMM) / (2 * focalLength))
            return round(toDegrees(deg) * 10) / 10
        }
    }
    
    var dDegrees : Double{
        get{
            let deg =  2 * atan((sensorDiagonal) / (2 * focalLength))
            return round(toDegrees(deg) * 10) / 10
        }
    }
  
    
    
    // Custom Function
    
    func toDegrees ( x : Double) -> Double{
        return (x > 0 ? x : (2 * M_PI + x)) * 360 / (2 * M_PI)
    }
}
