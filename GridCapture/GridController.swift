//
//  GridController.swift
//  GridCollectionView
//
//  Created by ben on 28/04/2016.
//  Copyright © 2016 Park Bench. All rights reserved.
//

import Cocoa

class GridController: NSObject {

    
    // MARK :PROPERTIES
    var slices : NSMutableArray = NSMutableArray()
    var columns : Int = 5
    var rows : Int = 5
    var startPosition = (x:0 , y:0)
    var endPosition = (x:0,y:0)
    var totalOfSlices : Int {
        get{
            return (Int(rows) * Int(columns))
        }
        set{
            
        }
    }

    @IBOutlet weak var arrayController : NSArrayController!
    
   
    // MARK: RUNTIME
    
    override func awakeFromNib() {
        
        for index in 1...10{
            // Optionnal Image to implement
//            let newImage : NSImage = NSImage(named: "gina")!
            let newSlice = Slice(indexFrame: index)
            self.slices.addObject(newSlice)
        }
        
    }
}
