//
//  RigViewController.swift
//  GridCapture
//
//  Created by ben on 02/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa

class RigViewController: NSViewController {
    let keys : NSNotificationCenterKeys = NSNotificationCenterKeys()
    
    @IBOutlet var rigView: RigView!
    @IBOutlet weak var circleView: NSView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.frame.origin = CGPointMake(0, 0)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RigViewController.updateCameraPosition), name: keys.cameraPositionKey, object: nil)
    }
    
    
    override func viewWillAppear() {
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RigViewController.updateCameraPosition), name: keys.cameraPositionKey, object: nil)
        
    }
    
    
    func updateCameraPosition(notification:NSNotification){
        
        guard let userInfo = notification.userInfo,
            let xInfo  = userInfo["xPosition"] as? Int,
            let yInfo = userInfo["yPosition"] as? Int
            else {
                print("No userInfo found in notification")
                return
        }
        let xPosFloat = (CGFloat(xInfo) / 75000 * self.view.frame.width) - circleView.frame.width/2
        let yPosFloat = (CGFloat(yInfo) / 75000 * self.view.frame.height)  - circleView.frame.height/2
        
        let newPosition = CGPointMake(xPosFloat, yPosFloat)
        
        circleView.frame.origin = newPosition
    }

    
}
