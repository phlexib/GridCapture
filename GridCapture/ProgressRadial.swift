//
//  ProgressRadial.swift
//  GridCapture
//
//  Created by ben on 09/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa

class ProgressRadial: NSView {
 
        private let progressLayer: CAShapeLayer = CAShapeLayer()
        
    
        
        required init?(coder aDecoder: NSCoder) {
           
            super.init(coder: aDecoder)
            self.wantsLayer = true
            createProgressLayer()
                   }
        
        override init(frame: CGRect) {
           
            super.init(frame: frame)
            self.wantsLayer = true
            createProgressLayer()
            
        }
        

        private func createProgressLayer() {
            let startAngle = CGFloat(M_PI_2)
            let endAngle = CGFloat(M_PI * 2 + M_PI_2)
            let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)

            
            let gradientMaskLayer = gradientMask()
          
            let oval2Rect = NSMakeRect((self.frame.midX), (self.frame.midY), 100, 100)
            let oval2Path = NSBezierPath()
            oval2Path.appendBezierPathWithArcWithCenter(centerPoint, radius: oval2Rect.width / 2, startAngle: 0, endAngle: 23, clockwise: true)
            

            let customPath = CGPathCreateMutable()
            CGPathAddArc(customPath, nil, oval2Rect.midX, oval2Rect.midY, oval2Rect.width/2, startAngle, endAngle, true)
//            customPath.appendBezierPathWithArcWithCenter(NSMakePoint(oval2Rect.midX, oval2Rect.midY), radius: oval2Rect.width / 2, startAngle: 0, endAngle: 23, clockwise: true)
            
            
            progressLayer.path = customPath

            progressLayer.backgroundColor = NSColor.blueColor().CGColor
            progressLayer.fillColor = nil
            progressLayer.strokeColor = NSColor.blackColor().CGColor
            progressLayer.lineWidth = 4.0
            progressLayer.strokeStart = 0.0
            progressLayer.strokeEnd = 0.0
            
            gradientMaskLayer.mask = progressLayer
            layer!.addSublayer(gradientMaskLayer)
        }
        
        private func gradientMask() -> CAGradientLayer {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            
            gradientLayer.locations = [0.0, 1.0]
            
            let colorTop: AnyObject = NSColor(red: 255.0/255.0, green: 213.0/255.0, blue: 63.0/255.0, alpha: 1.0).CGColor
            let colorBottom: AnyObject = NSColor(red: 255.0/255.0, green: 198.0/255.0, blue: 5.0/255.0, alpha: 1.0).CGColor
            let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
            gradientLayer.colors = arrayOfColors
            
            return gradientLayer
        }
        
        func hideProgressView() {
            progressLayer.strokeEnd = 0.0
            progressLayer.removeAllAnimations()
          
        }
        
        func animateProgressView() {
           
            progressLayer.strokeEnd = 0.0
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = CGFloat(0.0)
            animation.toValue = CGFloat(1.0)
            animation.duration = 5.0
            animation.delegate = self
            animation.removedOnCompletion = false
            animation.additive = true
            animation.fillMode = kCAFillModeForwards
            progressLayer.addAnimation(animation, forKey: "strokeEnd")
        }
        
        override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        }
    }


