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
    
    enum options {
        case empty
        case current
        case took
    }
    
    let tookColor = StyleKit.on
    let currentColor = StyleKit.standbye
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
            }
        }
    }
    var position = (x:0,y:0)
    var stepPosition = (x:0,y:0)
    
   
    
    init(indexFrame:Int) {
        
        self.indexFrame = indexFrame
        self.status = .empty
        //self.itemColor = self.emptyColor
        
    }
    
    
    func switchColor(){
        switch status{
            case .empty:  self.itemColor = emptyColor
            case .current:   self.itemColor = currentColor
            case .took:   self.itemColor = tookColor
       
        }
    }
    
        
}
