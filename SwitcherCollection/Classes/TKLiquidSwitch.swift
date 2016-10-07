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

open class TKLiquidSwitch: TKBaseSwitch, TKViewScale {
    
    
    fileprivate var bubbleLayer = CAShapeLayer()
    fileprivate var lineLayer   = CAShapeLayer()
    fileprivate var color = (on: UIColor(red:0.373,  green:0.843,  blue:0.596, alpha:1),
        off: UIColor(red:0.871,  green:0.871,  blue:0.871, alpha:1)) {
        didSet {
            setUpView()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override internal func setUpView() {
        super.setUpView()
        
        self.clipsToBounds = true
        
        lineLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 30, width: self.bounds.width, height: 20 * sizeScale), cornerRadius: 10 * sizeScale).cgPath
        lineLayer.fillColor = switchColor(true).cgColor
        lineLayer.position = CGPoint(x: 0, y: -10 * sizeScale)
        self.layer.addSublayer(lineLayer)
        
        bubbleLayer.frame = self.bounds
        bubbleLayer.position = bubblePosition(true)
        bubbleLayer.path = bubbleShapePath
        bubbleLayer.fillColor = switchColor(true).cgColor
        self.layer.addSublayer(bubbleLayer)
        
    }
    
    override internal func changeValue() {
        super.changeValue()
        changeStateAnimate(isOn, duration: self.animateDuration)
    }
    
    
    func changeStateAnimate(_ turnOn:Bool,duration:Double){
        
        

        let bubbleTransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        bubbleTransformAnim.values   = [NSValue(caTransform3D: CATransform3DIdentity),
                                        NSValue(caTransform3D: CATransform3DMakeScale(1, 0.8, 1)),
                                        NSValue(caTransform3D: CATransform3DMakeScale(0.8, 1, 1)),
                                        NSValue(caTransform3D: CATransform3DIdentity)]
        bubbleTransformAnim.keyTimes = [NSNumber(value: 0), NSNumber(value: 1.0 / 3.0), NSNumber(value: 2.0 / 3.0), NSNumber(value: 1)]
        bubbleTransformAnim.duration = duration
        
        let bubblePositionAnim = CABasicAnimation(keyPath: "position")
        bubblePositionAnim.fromValue =  NSValue(cgPoint: bubblePosition(!isOn))
        bubblePositionAnim.toValue   = NSValue(cgPoint: bubblePosition(isOn))
        bubblePositionAnim.duration  = duration
        
        let bubbleGroupAnim = CAAnimationGroup()
        bubbleGroupAnim.animations = [bubbleTransformAnim,bubblePositionAnim]
        bubbleGroupAnim.isRemovedOnCompletion = false
        bubbleGroupAnim.fillMode = kCAFillModeForwards
        bubbleGroupAnim.duration = duration
        

        bubbleLayer.add(bubbleGroupAnim, forKey: "Bubble")
        
        let color = switchColor(isOn).cgColor
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.lineLayer.fillColor = color
            self.bubbleLayer.fillColor = color
        }) 
    }
}


// Getter
extension TKLiquidSwitch{

    var bubbleShapePath : CGPath {
        let bubblePath = UIBezierPath()
        let CGPointScaleMake = CGPointScaleMaker(self.sizeScale)
        
        bubblePath.move(to: CGPointScaleMake(120.6, 34.75))
        bubblePath.addCurve(to: CGPointScaleMake(150, 50), controlPoint1: CGPointScaleMake(125.45, 43.71), controlPoint2: CGPointScaleMake(136.79, 50))
        bubblePath.addCurve(to: CGPointScaleMake(138.26, 51.75), controlPoint1: CGPointScaleMake(145.85, 50), controlPoint2: CGPointScaleMake(141.89, 50.62))
        bubblePath.addCurve(to: CGPointScaleMake(120.6, 65.25), controlPoint1: CGPointScaleMake(130.31, 54.21), controlPoint2: CGPointScaleMake(123.93, 59.1))
        bubblePath.addCurve(to: CGPointScaleMake(75, 100), controlPoint1: CGPointScaleMake(114.43, 85.41), controlPoint2: CGPointScaleMake(96.35, 100))
        bubblePath.addCurve(to: CGPointScaleMake(29.4, 65.25), controlPoint1: CGPointScaleMake(53.65, 100), controlPoint2: CGPointScaleMake(35.57, 85.41))
        bubblePath.addCurve(to: CGPointScaleMake(16.25, 53.48), controlPoint1: CGPointScaleMake(26.73, 60.31), controlPoint2: CGPointScaleMake(22.09, 56.19))
        bubblePath.addCurve(to: CGPointScaleMake(11.74, 51.75), controlPoint1: CGPointScaleMake(14.82, 52.81), controlPoint2: CGPointScaleMake(13.31, 52.23))
        bubblePath.addCurve(to: CGPointScaleMake(0, 50), controlPoint1: CGPointScaleMake(8.11, 50.62), controlPoint2: CGPointScaleMake(4.15, 50))
        bubblePath.addCurve(to: CGPointScaleMake(11, 48.48), controlPoint1: CGPointScaleMake(3.87, 50), controlPoint2: CGPointScaleMake(7.57, 49.46))
        bubblePath.addCurve(to: CGPointScaleMake(29.4, 34.75), controlPoint1: CGPointScaleMake(19.29, 46.09), controlPoint2: CGPointScaleMake(25.97, 41.09))
        bubblePath.addCurve(to: CGPointScaleMake(38.05, 18.2), controlPoint1: CGPointScaleMake(31.27, 28.64), controlPoint2: CGPointScaleMake(34.23, 23.04))
        bubblePath.addCurve(to: CGPointScaleMake(42.59, 13.21), controlPoint1: CGPointScaleMake(39.45, 16.43), controlPoint2: CGPointScaleMake(40.97, 14.76))
        bubblePath.addCurve(to: CGPointScaleMake(75, 0), controlPoint1: CGPointScaleMake(51.11, 5.01), controlPoint2: CGPointScaleMake(62.5, 0))
        bubblePath.addCurve(to: CGPointScaleMake(120.6, 34.75), controlPoint1: CGPointScaleMake(96.35, 0), controlPoint2: CGPointScaleMake(114.43, 14.59))
        bubblePath.close()
        return bubblePath.cgPath
    }
    
    func switchColor(_ isON:Bool)-> UIColor{
        if isOn{
            return color.on
        }
        else{
            return color.off
        }
    }
    
    func bubblePosition(_ isOn:Bool) -> CGPoint{
        let h = self.bounds.height
        let w = self.bounds.width
        
        if isOn{
            return CGPoint(x: h*5/6, y: h/2)
        }else{
            return CGPoint(x: w - h/3, y: h/2)
        }
    }
}


