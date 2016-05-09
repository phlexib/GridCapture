//
//  RigViewController.swift
//  GridCapture
//
//  Created by ben on 02/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa



class RigViewController: NSViewController{
    
    
    // MARK: - VARIABLES
    
    let keys : NSNotificationCenterKeys = NSNotificationCenterKeys()
    var cameraPosition = CGPoint()
    var displayPosition = CGPoint()
    var col = 5
    var ro = 5
    
    // MARK: - IBOUTLETS
    
    @IBOutlet var rigView: RigView!
    
    
    // MARK: - RUNTIME
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = StyleKit.rightMenu.CGColor

    }
    
 
    
    override func awakeFromNib() {
       
        
    }
    
   
    override func viewWillAppear() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridViewController.receiveGridInfo), name: keys.gridSettings, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RigViewController.updateCameraPositionFromNotification), name: keys.cameraPositionKey, object: nil)
        let prefs = NSUserDefaults.standardUserDefaults()
        let storedX = prefs.integerForKey("xPosition")
        cameraPosition.x = CGFloat(storedX)
        let storedY = prefs.integerForKey("yPosition")
        cameraPosition.y = CGFloat(storedY)
        
        print("fromn will appear position is \(storedX) and \(storedY)")
  
        updateCameraPosition()
       
        
        
    }
    
    
    //MARK: NOTIFICATIONS
    
    // Ge Grid Info
    func receiveGridInfo(notification : NSNotification){
        guard let userInfo = notification.userInfo,
             ro  = userInfo["rows"] as? Int,
             col = userInfo["columns"] as? Int
            else {
                print("No userInfo found in notification")
                return
        }
        print ("received infos : \(ro) and \(col)")
        rigView.columns = col
        rigView.rows = ro
        
//        repoRigView()
        
        
    }

    
    func updateCameraPositionFromNotification(notification:NSNotification){
        
        guard let userInfo = notification.userInfo,
            let xInfo  = userInfo["xPosition"] as? Int,
            let yInfo = userInfo["yPosition"] as? Int
            else {
                print("No userInfo found in notification")
                return
        }
        cameraPosition = CGPointMake(CGFloat(xInfo),CGFloat(yInfo))
        updateCameraPosition()
    }

    func updateCameraPosition(){
        
        let xPosFloat = (CGFloat(cameraPosition.x) / 10000 * self.view.frame.width)
        let yPosFloat = (CGFloat(cameraPosition.y) / 10000 * self.view.frame.height)
        
        displayPosition = CGPointMake(xPosFloat, yPosFloat)
        rigView.cameraPosition = displayPosition
        rigView.needsDisplay = true
        
            }

//    func repoRigView(){
//        rigView.frame.origin.x = self.view.frame.origin.x + (self.view.frame.width / CGFloat(col*2))
//        rigView.frame.origin.y = self.view.frame.origin.y + (self.view.frame.height / CGFloat(ro*2))
//        rigView.frame.size.width = self.view.frame.size.width - (self.view.frame.width / CGFloat(col))
//        rigView.frame.size.height = self.view.frame.size.height - (self.view.frame.height / CGFloat(ro))
//    }
    
}
