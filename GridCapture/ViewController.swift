//
//  ViewController.swift
//  CollectionViewElCapitan
//
//  Created by Klaas on 07.10.15.
//  Copyright © 2015 Park Bench. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSCollectionViewDataSource {
    
    // MARK: VARIABLES
    
    let keys : NSNotificationCenterKeys = NSNotificationCenterKeys()
    let moveProgress = NSProgress()
    let pictureProgress = NSProgress()
    var rig : Rig = Rig()
    var currentGrid : GridController = GridController()
    var slices : NSMutableArray = NSMutableArray()
    var currentFrameIndex = 0
    var rows : NSNumber = 5
    var columns : NSNumber = 5
    var xPosition: Int = 1
    var yPosition: Int = 1
    var currentPosition = (x:0,y:0)
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
    @IBOutlet weak var centerContainer: NSView!
    @IBOutlet weak var moveProgressWheel: NSProgressIndicator!
	@IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var horizontalSlider: NSSlider!
    @IBOutlet weak var verticalSLider: NSSlider!
    @IBOutlet weak var labelHorizontal: NSTextField!
    @IBOutlet weak var labelVertical: NSTextField!
    @IBOutlet weak var setGridBtn: NSButton!
    @IBOutlet weak var xPositionLabel: NSTextField!
    @IBOutlet weak var yPositionLabel: NSTextField!
    @IBOutlet weak var xStartPositionText: NSTextField!
    @IBOutlet weak var xEndPositionText: NSTextField!
    @IBOutlet weak var yStartPositionText: NSTextField!
    @IBOutlet weak var yEndPositionText: NSTextField!
    @IBOutlet weak var xStepLabel: NSTextField!
    
   
    // MARK: RUNTIME
	
    override func viewDidLoad() {
		super.viewDidLoad()
        
       
        // create default Rig
        
        rig = Rig(motorStepsRevolution: 200, rigMmWidth: 1500, rigMmHeight: 1500, circomference: 8, microStep: 2)
        
        
        // VIEW
        
        mainView.wantsLayer = true
        mainView.layer?.backgroundColor = StyleKit.rightMenu.CGColor
        scrollView.wantsLayer = true
        scrollView.layer?.backgroundColor = StyleKit.rightMenu.CGColor
        clipView.wantsLayer = true
        clipView.layer?.backgroundColor = StyleKit.rightMenu.CGColor
        
       
        // COLLECTIONVIEW 
        
		collectionView.dataSource = self
        collectionView.wantsLayer = true
        collectionView.maxNumberOfRows = 5
        collectionView.maxNumberOfColumns = 5
        currentGrid.slices = NSMutableArray(capacity: collectionView.maxNumberOfRows * collectionView.maxNumberOfColumns)
        collectionView.layer?.backgroundColor = StyleKit.rightMenu.CGColor
	
        // Variables to Default Values
        
        targetPosition = (0,0)
        xPositionLabel.stringValue = stringXPosition
        yPositionLabel.stringValue = stringYPosition
        
        
        // INIT Notification Observers
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateCameraPosition), name: keys.cameraPositionKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.moveToPosition), name: keys.moveTo, object: nil)
    }
    
    
    
    
    //MARK: IBActions

    // update collectionView with sliders
    @IBAction func changeSLider(sender: AnyObject) {
        
        // assign new values to CollectionView
        collectionView.maxNumberOfColumns = horizontalSlider.integerValue
        collectionView.maxNumberOfRows = verticalSLider.integerValue
        collectionView.setNeedsDisplayInRect(collectionView.frame)
        collectionView.reloadData()
        
        // set Grid Instance to CollectionView size
        currentGrid.rows = collectionView.maxNumberOfRows
        currentGrid.columns = collectionView.maxNumberOfColumns
        
        // Post Notification for Grid ViewController
        let gridNotification = ["rows" : collectionView.maxNumberOfRows, "columns" : collectionView.maxNumberOfColumns]
        NSNotificationCenter.defaultCenter().postNotificationName(keys.gridSettings, object: self, userInfo :gridNotification)
        
    }
    
    // update collectionView array and Grid
    @IBAction func setGrid(sender: AnyObject) {
        
        // post Notification to Set GridController
        NSNotificationCenter.defaultCenter().postNotificationName(keys.setGrid, object: self)
        print("Set Grid for current  Project")
        
    }
    
    
    // MARK : NSNOTIFICATIONCENTER
    
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
        
        let startPosition = currentPosition
        currentPosition.x = xInfo as! Int
        currentPosition.y = yInfo as! Int
        xPositionLabel.stringValue = String(currentPosition.x)
        yPositionLabel.stringValue = String(currentPosition.y)
        let xDestinationPosition = targetPosition.x
        let yDestinationPosition = targetPosition.x
        let xDistance = xDestinationPosition - startPosition.x
        let tempX =  currentPosition.x - startPosition.x
        let yDistance = yDestinationPosition - startPosition.y
        let tempY =  currentPosition.y - startPosition.y

        // Set NSProgress with current move 
        // TODO needs to get a percentage for the Pending count based on difference between X and Y distance
        
        let xMoveProgress = NSProgress(totalUnitCount: Int64(xDistance))
        xMoveProgress.completedUnitCount = Int64(tempX)
        let yMoveProgress = NSProgress(totalUnitCount: Int64(yDistance))
        yMoveProgress.completedUnitCount = Int64(tempY)
        moveProgress.totalUnitCount = Int64(xDestinationPosition)
        moveProgress.completedUnitCount = Int64(currentPosition.x)
        moveProgress.addChild(yMoveProgress, withPendingUnitCount: 50)
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
        let xTarget = Int(targetString.componentsSeparatedByString(",")[0])
        let yTarget = Int(targetString.componentsSeparatedByString(",")[1])
        targetPosition.x = xTarget!
        targetPosition.y = yTarget!
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


