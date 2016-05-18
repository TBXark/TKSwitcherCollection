//
//  TKLiquidSwitch.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/26.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit

// Dedign by Oleg Frolov
//https://dribbble.com/shots/2028065-Switcher-lll

class TKLiquidSwitch: TKBaseSwitch {
    
    
    var bubbleLayer = CAShapeLayer()
    var lineLayer   = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override func setUpView() {
        super.setUpView()
        
        self.clipsToBounds = true
        
        lineLayer.path = UIBezierPath(roundedRect: CGRectMake(0, 30, self.bounds.width, 20 * sizeScale), cornerRadius: 10 * sizeScale).CGPath
        lineLayer.fillColor = switchColor(true).CGColor
        lineLayer.position = CGPointMake(0, -10 * sizeScale)
        self.layer.addSublayer(lineLayer)
        
        bubbleLayer.frame = self.bounds
        bubbleLayer.position = bubblePosition(true)
        bubbleLayer.path = bubbleShapePath
        bubbleLayer.fillColor = switchColor(true).CGColor
        self.layer.addSublayer(bubbleLayer)
        
    }
    
    override func changeValue() {
        super.changeValue()
        changeStateAnimate(isOn, duration: self.animateDuration)
    }
    
    
    func changeStateAnimate(turnOn:Bool,duration:Double){
        

        let bubbleTransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        bubbleTransformAnim.values   = [NSValue(CATransform3D: CATransform3DIdentity),
                                        NSValue(CATransform3D: CATransform3DMakeScale(1, 0.8, 1)),
                                        NSValue(CATransform3D: CATransform3DMakeScale(0.8, 1, 1)),
                                        NSValue(CATransform3D: CATransform3DIdentity)]
        bubbleTransformAnim.keyTimes = [0, 1/3.0, 2/3.0, 1]
        bubbleTransformAnim.duration = duration
        
        let bubblePositionAnim = CABasicAnimation(keyPath: "position")
        bubblePositionAnim.fromValue =  NSValue(CGPoint: bubblePosition(!isOn))
        bubblePositionAnim.toValue   = NSValue(CGPoint: bubblePosition(isOn))
        bubblePositionAnim.duration  = duration
        
        let bubbleGroupAnim = CAAnimationGroup()
        bubbleGroupAnim.animations = [bubbleTransformAnim,bubblePositionAnim]
        bubbleGroupAnim.removedOnCompletion = false
        bubbleGroupAnim.fillMode = kCAFillModeForwards
        bubbleGroupAnim.duration = duration
        

        bubbleLayer.addAnimation(bubbleGroupAnim, forKey: "Bubble")
        
        let color = switchColor(isOn).CGColor
        UIView.animateWithDuration(duration) { () -> Void in
            self.lineLayer.fillColor = color
            self.bubbleLayer.fillColor = color
        }
    }
}


// Getter
extension TKLiquidSwitch{

    var bubbleShapePath : CGPathRef {
        let bubblePath = UIBezierPath()
        let CGPointScaleMake = CGPointScaleMaker(self.sizeScale)
        
        bubblePath.moveToPoint(CGPointScaleMake(120.6, 34.75))
        bubblePath.addCurveToPoint(CGPointScaleMake(150, 50), controlPoint1: CGPointScaleMake(125.45, 43.71), controlPoint2: CGPointScaleMake(136.79, 50))
        bubblePath.addCurveToPoint(CGPointScaleMake(138.26, 51.75), controlPoint1: CGPointScaleMake(145.85, 50), controlPoint2: CGPointScaleMake(141.89, 50.62))
        bubblePath.addCurveToPoint(CGPointScaleMake(120.6, 65.25), controlPoint1: CGPointScaleMake(130.31, 54.21), controlPoint2: CGPointScaleMake(123.93, 59.1))
        bubblePath.addCurveToPoint(CGPointScaleMake(75, 100), controlPoint1: CGPointScaleMake(114.43, 85.41), controlPoint2: CGPointScaleMake(96.35, 100))
        bubblePath.addCurveToPoint(CGPointScaleMake(29.4, 65.25), controlPoint1: CGPointScaleMake(53.65, 100), controlPoint2: CGPointScaleMake(35.57, 85.41))
        bubblePath.addCurveToPoint(CGPointScaleMake(16.25, 53.48), controlPoint1: CGPointScaleMake(26.73, 60.31), controlPoint2: CGPointScaleMake(22.09, 56.19))
        bubblePath.addCurveToPoint(CGPointScaleMake(11.74, 51.75), controlPoint1: CGPointScaleMake(14.82, 52.81), controlPoint2: CGPointScaleMake(13.31, 52.23))
        bubblePath.addCurveToPoint(CGPointScaleMake(0, 50), controlPoint1: CGPointScaleMake(8.11, 50.62), controlPoint2: CGPointScaleMake(4.15, 50))
        bubblePath.addCurveToPoint(CGPointScaleMake(11, 48.48), controlPoint1: CGPointScaleMake(3.87, 50), controlPoint2: CGPointScaleMake(7.57, 49.46))
        bubblePath.addCurveToPoint(CGPointScaleMake(29.4, 34.75), controlPoint1: CGPointScaleMake(19.29, 46.09), controlPoint2: CGPointScaleMake(25.97, 41.09))
        bubblePath.addCurveToPoint(CGPointScaleMake(38.05, 18.2), controlPoint1: CGPointScaleMake(31.27, 28.64), controlPoint2: CGPointScaleMake(34.23, 23.04))
        bubblePath.addCurveToPoint(CGPointScaleMake(42.59, 13.21), controlPoint1: CGPointScaleMake(39.45, 16.43), controlPoint2: CGPointScaleMake(40.97, 14.76))
        bubblePath.addCurveToPoint(CGPointScaleMake(75, 0), controlPoint1: CGPointScaleMake(51.11, 5.01), controlPoint2: CGPointScaleMake(62.5, 0))
        bubblePath.addCurveToPoint(CGPointScaleMake(120.6, 34.75), controlPoint1: CGPointScaleMake(96.35, 0), controlPoint2: CGPointScaleMake(114.43, 14.59))
        bubblePath.closePath()
        return bubblePath.CGPath
    }
    
    func switchColor(isON:Bool)-> UIColor{
        if isOn{
            return UIColor(red:0.373,  green:0.843,  blue:0.596, alpha:1)
        }
        else{
            return UIColor(red:0.871,  green:0.871,  blue:0.871, alpha:1)
        }
    }
    
    func bubblePosition(isOn:Bool) -> CGPoint{
        let h = self.bounds.height
        let w = self.bounds.width
        
        if isOn{
            return CGPointMake(h*5/6, h/2)
        }else{
            return CGPointMake(w - h/3, h/2)
        }
    }
}


