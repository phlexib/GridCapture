//
//  GridController.swift
//  GridCollectionView
//
//  Created by ben on 28/04/2016.
//  Copyright © 2016 Park Bench. All rights reserved.
//

import Cocoa

class GridController: NSObject {

    var slices : NSMutableArray = NSMutableArray()
    var columns : Int = 5
    var rows : Int = 5
    var startPosition = (x:0 , y:0)
    var endPosition = (x:0,y:0)
    
    var totalOfSlices : NSNumber {
        get{
            return (Int(rows) * Int(columns))
        }
        set{
            
        }
    }

    @IBOutlet weak var arrayController : NSArrayController!
    
    
    override func awakeFromNib() {
        
        for index in 1...10{
            let newImage : NSImage = NSImage(named: "gina")!
            let newSlice = Slice(indexFrame: index)
            
            self.slices.addObject(newSlice)
        }
        
    }
}
