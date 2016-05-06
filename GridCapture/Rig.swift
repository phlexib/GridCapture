//
//  Rig.swift
//  GridCollectionView
//
//  Created by ben on 28/04/2016.
//  Copyright © 2016 Park Bench. All rights reserved.
//

import Cocoa

class Rig{

        // MARK: VARIABLES
    
    
    // NEED TO IMPLEMENT COMPUTED PROPERTIES DIAMETER AND CIRCOMFERENCE DEPENDENCE
    // AND THEREFORE REDO THE INIT WITH diameter option
        var microStep : Int
        var motorStepsRevolution : Int
        var stepsRotation : Int
        let π = M_PI
        var circomference : Double
        var rigMmWidth : Double
        var rigMmHeight : Double
        var isHome : Bool = false
        var cameraPosition = (x:0,y:0)

    
        var diameter : Double {
            get{
                return circomference / π
            }
            set{
                circomference = diameter * π
            }
        }
    
    
        var stepMm : Double {
            get{
                return (Double(stepsRotation)/circomference)
            }
        }
        
        var rigStepWidth : Int{
            get{
                return Int(rigMmWidth * stepMm)
            }
        }
        var rigStepHeight : Int{
            get{
                return Int(rigMmHeight * stepMm)
            }
        }
        
    
        
        // MARK: INIT
    
    //default init()
    init(){
        self.microStep = 2
        self.motorStepsRevolution = 200
        self.circomference = 8
        self.stepsRotation =  motorStepsRevolution * microStep
        self.rigMmWidth = 1500
        self.rigMmHeight = 1500
        //            self.diameter
        self.stepMm
        self.rigStepWidth
        self.rigStepHeight
        self.isHome = false
        self.cameraPosition = (0,0)
    }
    
    
    // init with parameters
    init(motorStepsRevolution:Int,rigMmWidth:Double, rigMmHeight:Double, circomference:Double, microStep:Int){
        
        self.microStep = microStep
        self.motorStepsRevolution = motorStepsRevolution
        self.circomference = circomference
        self.stepsRotation =  motorStepsRevolution * microStep
        self.rigMmWidth = rigMmWidth
        self.rigMmHeight = rigMmHeight
        self.stepMm
        self.rigStepWidth
        self.rigStepHeight
        self.isHome = false
        self.cameraPosition = (0,0)
            
        }
    
    
        // MARK: DESCRIPTION
        
        func description()->String{
            
            let descriptionString = "Rig  is \(self.rigMmWidth) mm width by \(self.rigMmHeight) mm height. Resolution is \(stepMm)  steps / mm."
            
            return descriptionString
        }
        
        
    }
   