//
//  TKSimpleSwitch.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit

// Dedign by Oleg Frolov
//https://dribbble.com/shots/1990516-Switcher
//https://dribbble.com/shots/2165675-Switcher-V



public struct TKSimpleSwitchConfig {
    var onColor     : UIColor = UIColor(red:0.341,  green:0.914,  blue:0.506, alpha:1)
    var offColor    : UIColor = UIColor(white: 0.9, alpha: 1)
    var lineColor   : UIColor = UIColor(white: 0.8, alpha: 1)
    var circleColor : UIColor = UIColor.white
    var lineSize : Double = 10

}

open class TKSimpleSwitch:  TKBaseSwitch, TKViewScale {
    
    fileprivate var swichControl = CAShapeLayer()
    fileprivate var backgroundLayer = CAShapeLayer()
    
    // 是否加旋转特效
    open var rotateWhenValueChange = false
    
    open var config = TKSimpleSwitchConfig() {
        didSet {
            setUpView()
        }
    }
    
    open var lineWidth : CGFloat {
        return CGFloat(config.lineSize) * sizeScale
    }
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    
    // 初始化 View
    override internal func setUpView() {
        super.setUpView()
        self.backgroundColor = UIColor.clear
        let frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let radius = self.bounds.height/2 - lineWidth
        let roundedRectPath = UIBezierPath(roundedRect:frame.insetBy(dx: lineWidth, dy: lineWidth) , cornerRadius:radius)
        backgroundLayer.fillColor = stateToFillColor(true)
        backgroundLayer.strokeColor = config.lineColor.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.path = roundedRectPath.cgPath
        self.layer.addSublayer(backgroundLayer)
        
        let innerLineWidth =  self.bounds.height - lineWidth*3 + 1
        let swichControlPath = UIBezierPath()
        swichControlPath.move(to: CGPoint(x: lineWidth, y: 0))
        swichControlPath.addLine(to: CGPoint(x: self.bounds.width - 2 * lineWidth - innerLineWidth + 1, y: 0))
        var point = backgroundLayer.position
        point.y += (radius + lineWidth)
        point.x += (radius)
        swichControl.position = point
        swichControl.path = swichControlPath.cgPath
        swichControl.lineCap     = kCALineCapRound
        swichControl.fillColor   = nil
        swichControl.strokeColor = config.circleColor.cgColor
        swichControl.lineWidth   = innerLineWidth
        swichControl.strokeEnd = 0.0001
        self.layer.addSublayer(swichControl)
        

    }
    
    
    override public func changeValue() {
        super.changeValue()
        changeValueAnimate(isOn,duration: animateDuration)
    }
    
    
    // MARK: - Animate
    open func changeValueAnimate(_ turnOn:Bool, duration:Double) {
        
        
        let times = [0,0.49,0.51,1]
        
        
        // 线条运动动画
        let swichControlStrokeStartAnim      = CAKeyframeAnimation(keyPath:"strokeStart")
        swichControlStrokeStartAnim.values   = turnOn ? [1,0,0, 0] : [0,0,0,1]
        swichControlStrokeStartAnim.keyTimes = times as [NSNumber]?
        swichControlStrokeStartAnim.duration = duration
        swichControlStrokeStartAnim.isRemovedOnCompletion = true
        
        let swichControlStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        swichControlStrokeEndAnim.values   = turnOn ? [1,1,1,0] : [0,1,1,1]
        swichControlStrokeEndAnim.keyTimes = times as [NSNumber]?
        swichControlStrokeEndAnim.duration = duration
        swichControlStrokeEndAnim.isRemovedOnCompletion = true
        
        
        
        // 颜色动画
        let backgroundFillColorAnim      = CAKeyframeAnimation(keyPath:"fillColor")
        backgroundFillColorAnim.values   = [stateToFillColor(!turnOn),
                                            stateToFillColor(!turnOn),
                                            stateToFillColor(turnOn),
                                            stateToFillColor(turnOn)]
        backgroundFillColorAnim.keyTimes = [0,0.5,0.51,1]
        backgroundFillColorAnim.duration = duration
        backgroundFillColorAnim.fillMode = kCAFillModeForwards
        backgroundFillColorAnim.isRemovedOnCompletion = false
        

        // 旋转动画
        if rotateWhenValueChange{
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.transform = self.transform.rotated(by: CGFloat(M_PI))
            })
        }
        
        
        // 动画组
        let swichControlChangeStateAnim : CAAnimationGroup = CAAnimationGroup()
        swichControlChangeStateAnim.animations = [swichControlStrokeStartAnim,swichControlStrokeEndAnim]
        swichControlChangeStateAnim.fillMode = kCAFillModeForwards
        swichControlChangeStateAnim.isRemovedOnCompletion = false
        swichControlChangeStateAnim.duration = duration

        let animateKey = turnOn ? "TurnOn" : "TurnOff"
        swichControl.add(swichControlChangeStateAnim, forKey: animateKey)
        backgroundLayer.add(backgroundFillColorAnim, forKey: "Color")
    }
    
    fileprivate func stateToFillColor(_ isOn:Bool) -> CGColor {
        return isOn ?  config.onColor.cgColor : config.offColor.cgColor
    }
    
}
