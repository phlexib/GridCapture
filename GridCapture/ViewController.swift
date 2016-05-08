//
//  ViewController.swift
//  CollectionViewElCapitan
//
//  Created by Klaas on 07.10.15.
//  Copyright © 2015 Park Bench. All rights reserved.
//

import Cocoa



class ViewController: NSViewController, ContainerToMaster {

    // MARK: VARIABLES
    
    let keys : NSNotificationCenterKeys = NSNotificationCenterKeys()
    let moveProgress = NSProgress()
    let pictureProgress = NSProgress()
    var rig : Rig = Rig()
    var grid : GridController = GridController()
    var centerRigViewController: RigViewController?
    var centerGridViewController: GridViewController?
    var slices : NSMutableArray = NSMutableArray()
    var currentFrameIndex = 0
    var rows : Int = 5
    var columns : Int = 5
    var xPosition: Int = 1
    var yPosition: Int = 1
    var currentPosition = (x:0,y:0)
    var startPosition = (x:0,y:0)
    var targetPosition = (x:0,y:0)
    var stringXPosition : String{
        get{
            let xString = "Current X Position : "
            return xString + String(xPosition)
        }
    }
    var stringYPosition : String{
        get{
            let yString = "Current Y Position : "
            return yString + String(yPosition)
        }
    }
    
    
    
    // MARK: -IBOUTLETS 
    
    @IBOutlet weak var mainView: NSView!
    @IBOutlet weak var scrollView: NSView!
    @IBOutlet weak var clipView: NSView!
    @IBOutlet weak var centerContainerView: NSView!
    @IBOutlet weak var moveProgressWheel: NSProgressIndicator!
    @IBOutlet weak var horizontalSlider: NSSlider!
    @IBOutlet weak var verticalSLider: NSSlider!
    @IBOutlet weak var labelHorizontal: NSTextField!
    @IBOutlet weak var labelVertical: NSTextField!
    @IBOutlet weak var setGridBtn: NSButton!
    @IBOutlet weak var xPositionLabel: NSTextField!
    @IBOutlet weak var yPositionLabel: NSTextField!
    @IBOutlet weak var arduinoCallback: NSTextField!
    
   
    // MARK: RUNTIME
	
    override func viewDidLoad() {
		super.viewDidLoad()
        
       
        // create default Rig
        
        rig = Rig(motorStepsRevolution: 200, rigMmWidth: 1500, rigMmHeight: 1500, circomference: 8, microStep: 2)
        
        
        // VIEW
        
        mainView.wantsLayer = true
        mainView.layer?.backgroundColor = StyleKit.rightMenu.CGColor
                
       
        // COLLECTIONVIEW 
       
	
        // Variables to Default Values
        
        targetPosition = (0,0)
        xPositionLabel.stringValue = stringXPosition
        yPositionLabel.stringValue = stringYPosition
        
        
        // INIT Notification Observers
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateCameraPosition), name: keys.cameraPositionKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.moveToPosition), name: keys.moveTo, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateCallback), name: keys.arduinoCallback, object: nil)
    }
    
    
    
    
    //MARK: IBActions

    // update collectionView with sliders
    @IBAction func changeSLider(sender: AnyObject) {

        // set Grid Instance to CollectionView size
        
    let col = horizontalSlider.integerValue
    let ro = verticalSLider.integerValue
        
        // Post Notification for Grid ViewController
        let gridNotification = ["rows" : ro, "columns" : col]
        NSNotificationCenter.defaultCenter().postNotificationName(keys.gridSettings, object: self, userInfo :gridNotification)
        
    }
    
    // update collectionView array and Grid
    @IBAction func setUpGrid(sender: AnyObject) {
        
        // post Notification to Set GridController
        NSNotificationCenter.defaultCenter().postNotificationName(keys.setUpGrid, object: self)
        print("Set Grid for current  Project")
        
        
    }
    
    
    func updateInfo(text: String) {
        yPositionLabel.stringValue = text
    }
    
    // MARK : NSNOTIFICATIONCENTER
    
    func updateCallback(notification:NSNotification) {
        guard let userInfo = notification.userInfo,
            let arduinoInfo  = userInfo["callback"] as? String
            else {
                print("No userInfo found in notification")
                return
        }
        arduinoCallback.stringValue = arduinoInfo
    }
    
    // update callbacks UI and progress bar to new position
    func updateCameraPosition(notification:NSNotification){
       
        
        // get info form notification
        
        guard let userInfo = notification.userInfo,
            let xInfo  = userInfo["xPosition"],
            let yInfo = userInfo["yPosition"]
            else {
                print("No userInfo found in notification")
                return
        }
        
        // prep variables for NSProgress
        
        
        currentPosition.x = xInfo as! Int
        currentPosition.y = yInfo as! Int
        xPositionLabel.stringValue = String(currentPosition.x)
        yPositionLabel.stringValue = String(currentPosition.y)
        
    }
    
    func updateProgress(){
        
        let xDestinationPosition = targetPosition.x
        let yDestinationPosition = targetPosition.y
        let xDistance = abs(xDestinationPosition - startPosition.x)
        let tempX =  abs(currentPosition.x - startPosition.x)
        let yDistance = abs(yDestinationPosition - startPosition.y)
        let tempY =  abs(currentPosition.y - startPosition.y)
        let completedXy = tempX + tempY
        let xyDistance = xDistance + yDistance
        
        moveProgress.totalUnitCount = Int64(xyDistance)
        moveProgress.completedUnitCount = Int64(completedXy)
        xPositionLabel.stringValue = moveProgress.localizedDescription
        
        // update progress Wheel
        moveProgressWheel.doubleValue = moveProgress.fractionCompleted*100


    }
    // Set X and Y Target Position from Grid
    func moveToPosition(notification : NSNotification){
       
        // get notification
        guard let userInfo = notification.userInfo,
            let targetString  = userInfo["moveTo"] as? String
            else {
                print("No userInfo found in notification")
                return
        }
        print(targetString)
       
        let xTarget = Int(targetString.componentsSeparatedByString(",")[0])
        let yTarget = Int(targetString.componentsSeparatedByString(",")[1])
        targetPosition.x = xTarget!
        targetPosition.y = yTarget!
    }
    
    
    func progress(){
        
    }
    
    
    // MARK: PASSING DATA 
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "centerContainersegue" {
            let containerControllers = segue.destinationController as! NSTabViewController
            centerRigViewController = containerControllers.childViewControllers[0] as? RigViewController
            centerGridViewController = containerControllers.childViewControllers[1] as? GridViewController
            
            let newPosition = CGPointMake(CGFloat(currentPosition.x), CGFloat(currentPosition.y))
            centerRigViewController!.cameraPosition = newPosition
            centerRigViewController!.updateCameraPosition()
            
            
//            grid.slices = NSMutableArray(capacity: columns * rows)
//            centerGridViewController?.grid = grid
            }
        
        
    }

    
    func changeLabel(text:String){
        yPositionLabel.stringValue = text
    }
   	//MARK: NSCollectionViewDataSource
	
	func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionView.maxNumberOfRows * collectionView.maxNumberOfColumns
	}
    
	
	func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
		
        let item = collectionView.makeItemWithIdentifier("LabelCollectionViewItem", forIndexPath: indexPath)
        item.representedObject = Slice(indexFrame: indexPath.item+1)
        
        item.view.wantsLayer = true
        item.view.layer?.backgroundColor = StyleKit.oval15Copy3.CGColor
		return item
	}
}


