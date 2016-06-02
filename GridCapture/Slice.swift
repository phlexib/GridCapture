//
//  Slice.swift
//  GridCollectionView
//
//  Created by ben on 22/04/2016.
//  Copyright © 2016 Park Bench. All rights reserved.
//

import Foundation
import AppKit

class Slice: NSObject {
    
    let keys = NSNotificationCenterKeys()
    
    
    // MARK : CLASS PROPERTIES
    enum options {
        case empty
        case standbye
        case current
        case took
    }
    
    var position = (x:0,y:0)
    var stepPosition = (x:0,y:0)
    let tookColor = StyleKit.on
    let currentColor = StyleKit.standbye
    let standbyeColor = StyleKit.off
    let emptyColor = StyleKit.oval15Copy3
    var indexFrame : Int
    var status : options
    var itemColor : NSColor{
        set{
             newValue
        }
        get{
            switch status{
            case .empty:  return emptyColor
            case .current:   return currentColor
            case .took:   return tookColor
            case .standbye: return standbyeColor
            }
        }
    }
    
    
    // MARK: INIT
    
    init(indexFrame:Int) {
        
        self.indexFrame = indexFrame
        self.status = .empty
        
    }
    
    
    // MARK: CLASS FUNCTIONS
    
    // get position from Grid
    func getPosition(itemIndex : Int , maxRows: Int, maxColumns : Int)-> (x: Int, y: Int){
        // Get X and Y Index from CollectionView
        
        var sliceColumn = itemIndex % maxColumns
        
        if sliceColumn == 0{
            sliceColumn = maxColumns
        }
        
        
        let sliceRowFloat =   Float(self.indexFrame) / Float(maxColumns)
        let sliceRow = Int(ceil(sliceRowFloat))
        
        return (sliceColumn,sliceRow)
        
    }

    // go to frame
    func goToFrame() {
        self.status = .standbye
        print ("GO TO POSITION\(self.stepPosition)")
        
        let xString = String(self.stepPosition.x)
        let yString = String(self.stepPosition.y)
        let string = xString + "," + yString
        
        let moveToInfo = ["moveTo" : string]
        NSNotificationCenter.defaultCenter().postNotificationName(keys.moveTo, object: self, userInfo: moveToInfo)
        
        
    }

    // go to frame with callback
    func goToFrameWithcallBack(completion: () -> Void) {
        self.status = .standbye
        print ("GO TO POSITION\(self.stepPosition)")
        
        let xString = String(self.stepPosition.x)
        let yString = String(self.stepPosition.y)
        let string = xString + "," + yString
        
        let moveToInfo = ["moveTo" : string]
        NSNotificationCenter.defaultCenter().postNotificationName(keys.moveTo, object: self, userInfo: moveToInfo)
        
        if self.status == .current{
            completion()
            
        }else{
            
        }
    }

    
}
