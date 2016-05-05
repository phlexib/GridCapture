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
    
   
    var rig : Rig = Rig()
    var currentGrid : GridController = GridController()
    var slices : NSMutableArray = NSMutableArray()
    var currentFrameIndex = 0
    
    var rows : NSNumber = 5
    var columns : NSNumber = 5
    
    var xPosition: Int = 1
       
    var yPosition: Int = 1
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
    
    enum TabIndex : Int {
        case FirstChildTab = 0
        case SecondChildTab = 1
    }
    
    @IBOutlet weak var mainView: NSView!
    @IBOutlet weak var scrollView: NSView!
    @IBOutlet weak var clipView: NSView!
    @IBOutlet weak var centerContainer: NSView!
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    
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
    
    // MARK : Runtime
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
//        collectionView.content = currentGrid.slices as [AnyObject]
        collectionView.wantsLayer = true
        collectionView.maxNumberOfRows = 5
        collectionView.maxNumberOfColumns = 5
        currentGrid.slices = NSMutableArray(capacity: collectionView.maxNumberOfRows * collectionView.maxNumberOfColumns)
        collectionView.layer?.backgroundColor = StyleKit.rightMenu.CGColor
	
       
        xPositionLabel.stringValue = stringXPosition
        yPositionLabel.stringValue = stringYPosition
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateCameraPosition), name: keys.cameraPositionKey, object: nil)
    }
    
    
    
    
    //MARK: IBActions
    
    @IBAction func changedCenterView(sender: NSSegmentedControl) {
           }
    
    @IBAction func changeHorizontal(sender: AnyObject) {
        
        collectionView.maxNumberOfColumns = horizontalSlider.integerValue
        collectionView.maxNumberOfRows = verticalSLider.integerValue
        collectionView.setNeedsDisplayInRect(collectionView.frame)
        collectionView.reloadData()
        currentGrid.rows = collectionView.maxNumberOfRows
        currentGrid.columns = collectionView.maxNumberOfColumns
        
        let gridNotification = ["rows" : collectionView.maxNumberOfRows, "columns" : collectionView.maxNumberOfColumns]
        NSNotificationCenter.defaultCenter().postNotificationName(keys.gridSettings, object: self, userInfo :gridNotification)
        
        
    }
    
    @IBAction func setGrid(sender: AnyObject) {
        
        
        NSNotificationCenter.defaultCenter().postNotificationName(keys.setGrid, object: self)
        print("Set Grid for current  Project")
        
    }
    
    
    
    // MARK : NSNOTIFICATIONCENTER
    
    func updateCameraPosition(notification:NSNotification){
       
        guard let userInfo = notification.userInfo,
            let xInfo  = userInfo["xPosition"],
            let yInfo = userInfo["yPosition"]
            else {
                print("No userInfo found in notification")
                return
        }
        xPositionLabel.stringValue = String(xInfo)
        yPositionLabel.stringValue = String(yInfo)
    }
    
    //MARK: NSCollectionViewDelegate
    
   

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
    
    func addSubview(subView:NSView, toView parentView:NSView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func cycleFromViewController(oldViewController: NSViewController, toViewController newViewController: NSViewController) {
      
        oldViewController.removeFromParentViewController()
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.centerContainer!)
 
    }
}

