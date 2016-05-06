//
//  Grid.swift
//  CollectionViewElCapitan
//
//  Created by ben on 22/04/2016.
//  Copyright © 2016 Park Bench. All rights reserved.
//

import Cocoa

class Grid: NSObject {

    
    // MARK: VARIABLES
    var name: String
    var columns : NSNumber
    var rows : NSNumber
    var sliceArray : NSMutableArray
    var totalOfSlices : NSNumber {
        get{
          return (Int(rows) * Int(columns))
        }
        set{
            
        }
  }
    
    
    // MARK: INIT
    
    // Default Init
    init(name:String){
        
        self.name = name
        self.columns = 5
        self.rows = 5
        sliceArray = NSMutableArray(capacity: (Int(self.columns) * Int(self.rows)))
    }

    
    // INIT With Rows and Columns ---- TODO
    init(name:String,columns:NSNumber, rows:NSNumber){
        
        self.name = name
        self.columns = columns
        self.rows = rows
        sliceArray = NSMutableArray(capacity: (Int(self.columns) * Int(self.rows)))
    }

}
