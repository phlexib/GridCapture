//
//  GridViewController.swift
//  GridCapture
//
//  Created by ben on 04/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa

class GridViewController: NSViewController, NSCollectionViewDataSource {

    // MARK: VARIABLES
    let keys : NSNotificationCenterKeys = NSNotificationCenterKeys()
    
    @IBOutlet weak var testLabelNotification: NSTextField!
    
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
    @IBOutlet weak var collectionView: NSCollectionView!
    
    
    override func viewWillAppear() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridViewController.receiveGridInfo), name: keys.gridSettings, object: nil)
    }
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
        
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateCameraPosition), name: keys.cameraPositionKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridViewController.setGrid), name: keys.setGrid, object: nil)
    }
    
    
    func receiveGridInfo(notification : NSNotification){
        guard let userInfo = notification.userInfo,
            let ro  = userInfo["rows"] as? Int,
            let col = userInfo["columns"] as? Int
            else {
                print("No userInfo found in notification")
                return
        }
        
        rows = ro
        columns = col
        
        collectionView.maxNumberOfColumns = Int(columns)
        collectionView.maxNumberOfRows = Int(rows)
        currentGrid.slices = NSMutableArray(capacity: collectionView.maxNumberOfRows * collectionView.maxNumberOfColumns)
        collectionView.reloadData()
        
    }
    
    
    //MARK: IBActions

    func setGrid(notification:NSNotification) {
    
                currentGrid.slices=[]
        
        collectionView.maxNumberOfRows = Int(rows)
        collectionView.maxNumberOfColumns = Int(columns)
        

        
        for index in 0..<collectionView.numberOfItemsInSection(0){
            
            let pathIndex = NSIndexPath(forItem: index, inSection: 0)
            let collItem = (collectionView.itemAtIndexPath(pathIndex) as! LabelCollectionViewItem)
            let sliceItem = collItem.representedObject as! Slice!
            sliceItem.indexFrame = index+1
            sliceItem.position = collItem.getPosition(index+1, maxRows: collectionView.maxNumberOfRows, maxColumns: collectionView.maxNumberOfColumns)
            currentGrid.slices.addObject(collItem)
           
            
        }
        
        // temp position to step conversion
        currentGrid.startPosition = (0,0)
        currentGrid.endPosition = (1000,1000)
        currentGrid.rows = collectionView.maxNumberOfRows
        currentGrid.columns = collectionView.maxNumberOfColumns
        
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
        
       
        
        
        //        horizontalSlider.enabled = false
        //        verticalSLider.enabled = false
    }
    
    
    
    // MARK : NSNOTIFICATIONCENTER
    
        
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

