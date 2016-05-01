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
        
        var microStep : Int
        
        var motorStepsRevolution : Int
        var stepsRotation : Int
        let π = M_PI
        var diameter : Double {
            get{
                return circomference / π
            }
            set{
                
            }
        }
        
        
        var circomference : Double
        var rigMmWidth : Double
        var rigMmHeight : Double
        
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
        
        var isHome : Bool = false
        var cameraPosition = (x:0,y:0)
        
        
        // MARK: INIT
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
    
    init(motorStepsRevolution:Int,rigMmWidth:Double, rigMmHeight:Double, circomference:Double, microStep:Int){
            
            self.microStep = microStep
            self.motorStepsRevolution = motorStepsRevolution
            self.circomference = circomference
            self.stepsRotation =  motorStepsRevolution * microStep
            self.rigMmWidth = rigMmWidth
            self.rigMmHeight = rigMmHeight
//            self.diameter
            self.stepMm
            self.rigStepWidth
            self.rigStepHeight
            self.isHome = false
            self.cameraPosition = (0,0)
            
        }
        
        // MARK: FUNCTIONS
        
        func description()->String{
            
            let descriptionString = "Rig  is \(self.rigMmWidth) mm width by \(self.rigMmHeight) mm height. Resolution is \(stepMm)  steps / mm."
            
            return descriptionString
        }
        
        
    }
   