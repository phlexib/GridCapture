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
    
    @IBOutlet weak var mainView: NSView!
    @IBOutlet weak var scrollView: NSView!
    @IBOutlet weak var clipView: NSView!
    
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
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
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
    }
    
    
    
    
    //MARK: IBActions
    
    @IBAction func changeHorizontal(sender: AnyObject) {
        
        collectionView.maxNumberOfColumns = horizontalSlider.integerValue
        collectionView.maxNumberOfRows = verticalSLider.integerValue
        collectionView.setNeedsDisplayInRect(collectionView.frame)
        collectionView.reloadData()
        
        
        currentGrid.rows = collectionView.maxNumberOfRows
        currentGrid.columns = collectionView.maxNumberOfColumns
        
    }
    
    @IBAction func setGrid(sender: AnyObject) {
        
        print("Set Grid for current  Project")
        
        
        currentGrid.slices=[]
        
        
        
        
        
        print(collectionView.numberOfItemsInSection(0))
    
        let col = collectionView.maxNumberOfColumns
        let ro = collectionView.maxNumberOfRows
        
        
        
        for index in 0..<collectionView.numberOfItemsInSection(0){

            let pathIndex = NSIndexPath(forItem: index, inSection: 0)
            let collItem = (collectionView.itemAtIndexPath(pathIndex) as! LabelCollectionViewItem)
            let sliceItem = collItem.representedObject as! Slice!
            sliceItem.indexFrame = index+1
            sliceItem.position = collItem.getPosition(index+1, maxRows: ro, maxColumns: col)
            currentGrid.slices.addObject(collItem)
            
            
        }
        
        // temp position to step conversion
        currentGrid.startPosition = (Int(xStartPositionText.intValue), Int(yStartPositionText.intValue))
        currentGrid.endPosition = (Int(xEndPositionText.intValue), Int(yEndPositionText.intValue))
        let interXDistance = (currentGrid.endPosition.x - currentGrid.startPosition.x) / (currentGrid.columns-1)
        let interYDistance = (currentGrid.endPosition.y - currentGrid.startPosition.y) / (currentGrid.rows-1)
        
        let firstItem = currentGrid.slices[0] as! LabelCollectionViewItem
        firstItem.slice!.stepPosition = (currentGrid.startPosition.x,currentGrid.startPosition.y)
        
        
        for i in 0..<(currentGrid.slices.count)  {
            let theSliceItem = currentGrid.slices[i] as! LabelCollectionViewItem
            let itemX = currentGrid.startPosition.x + (theSliceItem.slice!.position.x * interXDistance)-interXDistance
            let itemY = currentGrid.endPosition.y - (currentGrid.startPosition.y + (theSliceItem.slice!.position.y * interYDistance)-interYDistance)
            
            let itemPos = (itemX,itemY)
            
            theSliceItem.slice!.stepPosition = itemPos
            print(theSliceItem.slice!.stepPosition)
        }
        
        let oneSLice = currentGrid.slices[0] as! LabelCollectionViewItem
        
        print (oneSLice.slice!.position)

        //        horizontalSlider.enabled = false
        //        verticalSLider.enabled = false
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
    
    
}

