//
//  Grid.swift
//  CollectionViewElCapitan
//
//  Created by ben on 22/04/2016.
//  Copyright © 2016 Park Bench. All rights reserved.
//

import Cocoa

class Grid: NSObject {

    var name: String
    var columns : NSNumber
    var rows : NSNumber
    
    
    var sliceArray : NSMutableArray = NSMutableArray()
    
    var totalOfSlices : NSNumber {
        get{
          return (Int(rows) * Int(columns))
        }
        set{
            
        }
    }
    
    init(name:String){
        
        self.name = name
        self.columns = 5
        self.rows = 5
       
        
        
    }
    
}
