//
//  TKExchangeSwitch.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit
// Dedign by Oleg Frolov
//https://dribbble.com/shots/2238916-Switcher-VI

class TKExchangeSwitch:  TKMainSwitch{

    // MARK: - Property
    var swichControl : TKExchangeCircleView!
    var backgroundLayer = CAShapeLayer()
        
    var switchColor : UIColor = UIColor(white: 0.95, alpha: 1)
    var onColor     : UIColor = UIColor(red:0.698,  green:1,  blue:0.353, alpha:1)
    var offColor    : UIColor = UIColor(red:0.812,  green:0.847,  blue:0.863, alpha:1)
    
    var lineSize        : Double = 20
    
    // MARK: - Getter
    var lineWidth : CGFloat {
        return CGFloat(lineSize) * sizeScale
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    // MARK: - Private Func
    override func setUpView(){
        super.setUpView()
        
        let radius = self.bounds.height/2 - lineWidth
        let position = CGPointMake(radius, radius + lineWidth)
        
        let backLayerPath = UIBezierPath()
        backLayerPath.moveToPoint(CGPointMake(lineWidth, 0))
        backLayerPath.addLineToPoint(CGPointMake(self.bounds.width - 4 * lineWidth, 0))
        
        backgroundLayer.position = position
        backgroundLayer.fillColor = switchColor.CGColor
        backgroundLayer.strokeColor = switchColor.CGColor
        backgroundLayer.lineWidth = self.bounds.height
        backgroundLayer.lineCap = kCALineCapRound
        backgroundLayer.path = backLayerPath.CGPath
        self.layer.addSublayer(backgroundLayer)
        
        let swichRadius = self.bounds.height - lineWidth
        swichControl = TKExchangeCircleView(frame: CGRectMake(lineWidth/2, lineWidth/2, swichRadius, swichRadius))
        swichControl.onLayer.fillColor = onColor.CGColor
        swichControl.offLayer.fillColor = offColor.CGColor
        self.addSubview(swichControl)
    }
    
    
    override func changeValue() {
        super.changeValue()
        changeValueAnimate(isOn,duration: animateDuration)
    }
    
    // MARK: - Animate
    func changeValueAnimate(turnOn:Bool, duration:Double){
        
        let keyTimes = [0,0.4,0.6,1]
        var frame    = self.swichControl.frame
        frame.origin.x = turnOn ? lineWidth/2 : (self.bounds.width - self.bounds.height + lineWidth/2)
        
        let swichControlStrokeStartAnim      = CAKeyframeAnimation(keyPath:"strokeStart")
        swichControlStrokeStartAnim.values   = [0,0.45,0.45, 0]
        swichControlStrokeStartAnim.keyTimes = keyTimes
        swichControlStrokeStartAnim.duration = duration
        swichControlStrokeStartAnim.removedOnCompletion = true
        
        let swichControlStrokeEndAnim      = CAKeyframeAnimation(keyPath:"strokeEnd")
        swichControlStrokeEndAnim.values   = [1,0.55,0.55, 1]
        swichControlStrokeEndAnim.keyTimes = keyTimes
        swichControlStrokeEndAnim.duration = duration
        swichControlStrokeEndAnim.removedOnCompletion = true
        
        let swichControlChangeStateAnim : CAAnimationGroup = CAAnimationGroup()
        swichControlChangeStateAnim.animations = [swichControlStrokeStartAnim,swichControlStrokeEndAnim]
        swichControlChangeStateAnim.fillMode = kCAFillModeForwards
        swichControlChangeStateAnim.removedOnCompletion = false
        swichControlChangeStateAnim.duration = duration
        
        backgroundLayer.addAnimation(swichControlChangeStateAnim, forKey: "SwitchBackground")
        swichControl.exchangeAnimate(turnOn, duration: duration)
        
        UIView.animateWithDuration(duration) { () -> Void in
            self.swichControl.frame = frame
        }
    }
}

class TKExchangeCircleView : UIView {
    
    // MARK: - Property
    var onLayer  : CAShapeLayer = CAShapeLayer()
    var offLayer : CAShapeLayer = CAShapeLayer()
    
    
    // MARK: - Init
    override init(frame:CGRect) {
        super.init(frame:frame)
        setUpLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLayer()
    }
    
    
    
    // MARK: - Private Func
    private func setUpLayer(){
        let radius = min(self.bounds.width, self.bounds.height)
        
        offLayer.frame = CGRectMake(0, 0, radius, radius)
        offLayer.path = UIBezierPath(ovalInRect:CGRectMake(0, 0, radius, radius)).CGPath;
        offLayer.transform = CATransform3DMakeScale(0, 0, 1)
        self.layer.addSublayer(offLayer)
        
        onLayer.frame = CGRectMake(0, 0, radius, radius)
        onLayer.path =  UIBezierPath(ovalInRect:CGRectMake(0, 0, radius, radius)).CGPath;
        self.layer.addSublayer(onLayer)
    }
    
    
    func exchangeAnimate(turnOn:Bool,duration:Double){
    
        let fillMode : String = kCAFillModeForwards
        
        let hideValues = [NSValue(CATransform3D: CATransform3DMakeScale(0, 0, 1)),
                          NSValue(CATransform3D: CATransform3DIdentity)]
        
        let showValues = [NSValue(CATransform3D: CATransform3DIdentity),
                          NSValue(CATransform3D: CATransform3DMakeScale(0, 0, 1))]
        
        let showTimingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
        let hideTimingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 1, 1)
        
        let keyTimes   = [0,1]
        
        offLayer.zPosition = turnOn ? 1 : 0
        onLayer.zPosition = turnOn ? 0 : 1
        
        ////OffLayer animation
        let offLayerTransformAnim            = CAKeyframeAnimation(keyPath:"transform")
        offLayerTransformAnim.values         = turnOn ? hideValues : showValues
        offLayerTransformAnim.keyTimes       = keyTimes
        offLayerTransformAnim.duration       = duration
        offLayerTransformAnim.timingFunction = turnOn ? hideTimingFunction : showTimingFunction
        offLayerTransformAnim.fillMode       = fillMode
        offLayerTransformAnim.removedOnCompletion = false
        
        ////OnLayer animation
        let onLayerTransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        onLayerTransformAnim.values   = turnOn ? showValues : hideValues
        onLayerTransformAnim.keyTimes = keyTimes
        onLayerTransformAnim.duration = duration
        offLayerTransformAnim.timingFunction = turnOn ? showTimingFunction : hideTimingFunction
        onLayerTransformAnim.fillMode = fillMode
        onLayerTransformAnim.removedOnCompletion = false
        
        
        onLayer.addAnimation(onLayerTransformAnim, forKey: "OnAnimate")
        offLayer.addAnimation(offLayerTransformAnim, forKey: "OffAnimate")
    }
    
}



