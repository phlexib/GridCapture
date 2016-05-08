//
//  RigViewController.swift
//  GridCapture
//
//  Created by ben on 02/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa

protocol ContainerToMaster {
    
    func updateInfo(text:String)
}

class RigViewController: NSViewController{
    
    
    // MARK: - VARIABLES
    
    let keys : NSNotificationCenterKeys = NSNotificationCenterKeys()
    var cameraPosition = CGPoint()
    var containerToMaster:ContainerToMaster?
    
    // MARK: - IBOUTLETS
    
    @IBOutlet var rigView: RigView!
    @IBOutlet weak var circleView: NSView!
   
    
    
    // MARK: - RUNTIME
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.frame.origin = CGPointMake(0, 0)
    }
    
 
    
    override func viewWillAppear() {
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RigViewController.updateCameraPositionFromNotification), name: keys.cameraPositionKey, object: nil)
    }
    
    
    func updateInfo(text: String) {
        print("Trigger from Master ViewController")
    }
    
    
    //MARK: NOTIFICATIONS
    
    func updateCameraPositionFromNotification(notification:NSNotification){
        
        guard let userInfo = notification.userInfo,
            let xInfo  = userInfo["xPosition"] as? Int,
            let yInfo = userInfo["yPosition"] as? Int
            else {
                print("No userInfo found in notification")
                return
        }
        let xPosFloat = (CGFloat(xInfo) / 75000 * self.view.frame.width) - circleView.frame.width/2
        let yPosFloat = (CGFloat(yInfo) / 75000 * self.view.frame.height)  - circleView.frame.height/2
        
        cameraPosition = CGPointMake(xPosFloat, yPosFloat)
        
        circleView.frame.origin = cameraPosition
    }

    func updateCameraPosition(){
        
        let xPosFloat = (CGFloat(cameraPosition.x) / 75000 * self.view.frame.width) - circleView.frame.width/2
        let yPosFloat = (CGFloat(cameraPosition.y) / 75000 * self.view.frame.height)  - circleView.frame.height/2
        
        cameraPosition = CGPointMake(xPosFloat, yPosFloat)
        
        circleView.frame.origin = cameraPosition
    }

    
    
}
