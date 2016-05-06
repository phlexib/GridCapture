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
    
    
    // MARK : CLASS PROPERTIES
    enum options {
        case empty
        case current
        case took
    }
    
    var position = (x:0,y:0)
    var stepPosition = (x:0,y:0)
    var tookColor = StyleKit.on
    var currentColor = StyleKit.standbye
    var emptyColor = StyleKit.oval15Copy3
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
            }
        }
    }
    
    
    // MARK: INIT
    
    init(indexFrame:Int) {
        
        self.indexFrame = indexFrame
        self.status = .empty
    }
    
    
    // MARK: CLASS FUNCTIONS
    
    // use Status to change color
    func switchColor(){
        switch status{
            case .empty:  self.itemColor = emptyColor
            case .current:   self.itemColor = currentColor
            case .took:   self.itemColor = tookColor
        }
    }
    
        
}
