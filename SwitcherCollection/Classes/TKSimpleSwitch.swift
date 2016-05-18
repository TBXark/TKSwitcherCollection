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


class TKSimpleSwitch:  TKBaseSwitch{
    
    var swichControl = CAShapeLayer()
    var backgroundLayer = CAShapeLayer()
    
    // 是否加旋转特效
    var rotateWhenValueChange = false
    
    
    var onColor     : UIColor = UIColor(red:0.341,  green:0.914,  blue:0.506, alpha:1)
    var offColor    : UIColor = UIColor(white: 0.9, alpha: 1)
    var lineColor   : UIColor = UIColor(white: 0.8, alpha: 1)
    var circleColor : UIColor = UIColor.whiteColor()
    
    
    
    var lineSize : Double = 10
    
    var lineWidth : CGFloat {
        return CGFloat(lineSize) * sizeScale
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    
    // 初始化 View
    override func setUpView(){
        super.setUpView()
        self.backgroundColor = UIColor.clearColor()
        let frame = CGRectMake(0, 0, self.bounds.width, self.bounds.height)
        let radius = self.bounds.height/2 - lineWidth
        let roundedRectPath = UIBezierPath(roundedRect:CGRectInset(frame, lineWidth, lineWidth) , cornerRadius:radius)
        backgroundLayer.fillColor = stateToFillColor(true)
        backgroundLayer.strokeColor = lineColor.CGColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.path = roundedRectPath.CGPath
        self.layer.addSublayer(backgroundLayer)
        
        let innerLineWidth =  self.bounds.height - lineWidth*3 + 1
        let swichControlPath = UIBezierPath()
        swichControlPath.moveToPoint(CGPointMake(lineWidth, 0))
        swichControlPath.addLineToPoint(CGPointMake(self.bounds.width - 2 * lineWidth - innerLineWidth + 1, 0))
        var point = backgroundLayer.position
        point.y += (radius + lineWidth)
        point.x += (radius)
        swichControl.position = point
        swichControl.path = swichControlPath.CGPath
        swichControl.lineCap     = kCALineCapRound
        swichControl.fillColor   = nil
        swichControl.strokeColor = circleColor.CGColor
        swichControl.lineWidth   = innerLineWidth
        swichControl.strokeEnd = 0.0001
        self.layer.addSublayer(swichControl)
        

    }
    
    
    override func changeValue() {
        super.changeValue()
        changeValueAnimate(isOn,duration: animateDuration)
    }
    
    
    // MARK: - Animate
    func changeValueAnimate(turnOn:Bool, duration:Double){
        
        
        let times = [0,0.49,0.51,1]
        
        
        // 线条运动动画
        let swichControlStrokeStartAnim      = CAKeyframeAnimation(keyPath:"strokeStart")
        swichControlStrokeStartAnim.values   = turnOn ? [1,0,0, 0] : [0,0,0,1]
        swichControlStrokeStartAnim.keyTimes = times
        swichControlStrokeStartAnim.duration = duration
        swichControlStrokeStartAnim.removedOnCompletion = true
        
        let swichControlStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        swichControlStrokeEndAnim.values   = turnOn ? [1,1,1,0] : [0,1,1,1]
        swichControlStrokeEndAnim.keyTimes = times
        swichControlStrokeEndAnim.duration = duration
        swichControlStrokeEndAnim.removedOnCompletion = true
        
        
        
        // 颜色动画
        let backgroundFillColorAnim      = CAKeyframeAnimation(keyPath:"fillColor")
        backgroundFillColorAnim.values   = [stateToFillColor(!turnOn),
                                            stateToFillColor(!turnOn),
                                            stateToFillColor(turnOn),
                                            stateToFillColor(turnOn)]
        backgroundFillColorAnim.keyTimes = [0,0.5,0.51,1]
        backgroundFillColorAnim.duration = duration
        backgroundFillColorAnim.fillMode = kCAFillModeForwards
        backgroundFillColorAnim.removedOnCompletion = false
        

        // 旋转动画
        if rotateWhenValueChange{
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.transform = CGAffineTransformRotate(self.transform, CGFloat(M_PI))
            })
        }
        
        
        // 动画组
        let swichControlChangeStateAnim : CAAnimationGroup = CAAnimationGroup()
        swichControlChangeStateAnim.animations = [swichControlStrokeStartAnim,swichControlStrokeEndAnim]
        swichControlChangeStateAnim.fillMode = kCAFillModeForwards
        swichControlChangeStateAnim.removedOnCompletion = false
        swichControlChangeStateAnim.duration = duration

        let animateKey = turnOn ? "TurnOn" : "TurnOff"
        swichControl.addAnimation(swichControlChangeStateAnim, forKey: animateKey)
        backgroundLayer.addAnimation(backgroundFillColorAnim, forKey: "Color")
    }
    
    private func stateToFillColor(isOn:Bool) -> CGColorRef{
        return isOn ?  onColor.CGColor : offColor.CGColor
    }
    
}