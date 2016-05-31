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
    var rig : Rig = Rig()
    var hasArrived = true
    var grid : GridController = GridController()
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

    // MARK: IBOUTLETS
    
    @IBOutlet weak var mainView: NSView!
    @IBOutlet weak var scrollView: NSView!
    @IBOutlet weak var clipView: NSView!
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var testLabelNotification: NSTextField!

    
    // MARK : Runtime
    
    override func viewWillAppear() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridViewController.receiveGridInfo), name: keys.gridSettings, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridViewController.arrived), name: keys.arrivedAtTarget, object: nil)
        
    }
  
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
        grid.slices = NSMutableArray(capacity: collectionView.maxNumberOfRows * collectionView.maxNumberOfColumns)
        collectionView.layer?.backgroundColor = StyleKit.rightMenu.CGColor
        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GridViewController.setUpGrid), name: keys.setUpGrid, object: nil)
    }
    
    // MARK: NOTIFICATION
    
    
    // Ge Grid Info
    func receiveGridInfo(notification : NSNotification){
        guard let userInfo = notification.userInfo,
            let ro  = userInfo["rows"] as? Int,
            let col = userInfo["columns"] as? Int
            else {
                print("No userInfo found in notification")
                return
        }
        print ("received Grid infos : \(ro) and \(col)")
        rows = ro
        columns = col
        collectionView.maxNumberOfColumns = Int(columns)
        collectionView.maxNumberOfRows = Int(rows)
        grid.slices = NSMutableArray(capacity: collectionView.maxNumberOfRows * collectionView.maxNumberOfColumns)
        collectionView.reloadData()
        
    }
    
    
    
    //MARK: CUSTOM FUNCTIONS

    func setUpGrid(notification:NSNotification) {
    
        // reinit Grid Instance
        grid.slices=[]

        // set up collectionView
        collectionView.maxNumberOfRows = Int(rows)
        collectionView.maxNumberOfColumns = Int(columns)
        
        // Assign new Slices in Grid array
        
        for index in 0..<collectionView.numberOfItemsInSection(0){
            
            let pathIndex = NSIndexPath(forItem: index, inSection: 0)
            let collItem = (collectionView.itemAtIndexPath(pathIndex) as! LabelCollectionViewItem)
            let sliceItem = collItem.representedObject as! Slice!
            sliceItem.indexFrame = index+1
            sliceItem.position = collItem.getPosition(index+1, maxRows: collectionView.maxNumberOfRows, maxColumns: collectionView.maxNumberOfColumns)
            grid.slices.addObject(collItem)
           
            
        }
        
        // Convert UI Grid to Steps
        grid.startPosition = (0,0)
        grid.endPosition = (10000,10000)
        grid.rows = collectionView.maxNumberOfRows
        grid.columns = collectionView.maxNumberOfColumns
        
        
        
        let interXDistance = (grid.endPosition.x - grid.startPosition.x) / (grid.columns-1)
        let interYDistance = (grid.endPosition.y - grid.startPosition.y) / (grid.rows-1)
        
//        grid.startPosition.x = grid.startPosition.x
//        grid.startPosition.y = grid.startPosition.y
        
        let firstItem = grid.slices[0] as! LabelCollectionViewItem
        firstItem.slice!.stepPosition = (grid.startPosition.x,grid.startPosition.y)
        
        
        // Assign each Step Position to Slices
        for i in 0..<(grid.slices.count)  {
            let theSliceItem = grid.slices[i] as! LabelCollectionViewItem
            let itemX = grid.startPosition.x + (theSliceItem.slice!.position.x * interXDistance)-interXDistance
            let itemY = grid.endPosition.y - (grid.startPosition.y + (theSliceItem.slice!.position.y * interYDistance)-interYDistance)
            
            let itemPos = (itemX,itemY)
            
            theSliceItem.slice!.stepPosition = itemPos
            
            print(itemPos)
        }
        
        //        horizontalSlider.enabled = false
        //        verticalSLider.enabled = false
    }
    
    
    func arrived(){
        
        var currentItem = LabelCollectionViewItem()
        
        for i in 0..<grid.slices.count {
            let collectionItem = grid.slices[i] as! LabelCollectionViewItem
            if collectionItem.slice!.status == .current{
                currentItem = collectionItem
                print(i)
                break
            }
            
        }
        
        currentItem.slice?.status = .took
        currentItem.view.layer?.backgroundColor = currentItem.slice!.itemColor.CGColor
        hasArrived = true
    }
    
    func sequenceCapture(){
        
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

