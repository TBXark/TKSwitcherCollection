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

@IBDesignable
open class TKLiquidSwitch: TKBaseSwitch {
    
    
    private var bubbleLayer = CAShapeLayer()
    private var lineLayer   = CAShapeLayer()
    @IBInspectable open var onColor = UIColor(red:0.373,  green:0.843,  blue:0.596, alpha:1){
        didSet {
            setUpView()
        }
    }
    
    @IBInspectable open var offColor = UIColor(red:0.871,  green:0.871,  blue:0.871, alpha:1) {
        didSet {
            setUpView()
        }
    }
    
    
    override internal func setUpView() {
        super.setUpView()
        
        self.clipsToBounds = true
        
        lineLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: (self.bounds.height - 20 * sizeScale) / 2, width: self.bounds.width, height: 20 * sizeScale), cornerRadius: 10 * sizeScale).cgPath
        lineLayer.fillColor = switchColor(true).cgColor
        self.layer.addSublayer(lineLayer)
        
        bubbleLayer.frame = self.bounds
        bubbleLayer.position = bubblePosition(true)
        bubbleLayer.path = bubbleShapePath
        bubbleLayer.fillColor = switchColor(true).cgColor
        self.layer.addSublayer(bubbleLayer)
        
    }
    
    override internal func changeValue() {
        super.changeValue()
        
        let bubbleTransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        bubbleTransformAnim.values   = [NSValue(caTransform3D: CATransform3DIdentity),
                                        NSValue(caTransform3D: CATransform3DMakeScale(1, 0.8, 1)),
                                        NSValue(caTransform3D: CATransform3DMakeScale(0.8, 1, 1)),
                                        NSValue(caTransform3D: CATransform3DIdentity)]
        bubbleTransformAnim.keyTimes = [NSNumber(value: 0), NSNumber(value: 1.0 / 3.0), NSNumber(value: 2.0 / 3.0), NSNumber(value: 1)]
        bubbleTransformAnim.duration = animateDuration
        
        let bubblePositionAnim = CABasicAnimation(keyPath: "position")
        bubblePositionAnim.fromValue =  NSValue(cgPoint: bubblePosition(!isOn))
        bubblePositionAnim.toValue   = NSValue(cgPoint: bubblePosition(isOn))
        bubblePositionAnim.duration  = animateDuration
        
        let bubbleGroupAnim = CAAnimationGroup()
        bubbleGroupAnim.animations = [bubbleTransformAnim,bubblePositionAnim]
        bubbleGroupAnim.isRemovedOnCompletion = false
        bubbleGroupAnim.fillMode = kCAFillModeForwards
        bubbleGroupAnim.duration = animateDuration
        
        
        bubbleLayer.add(bubbleGroupAnim, forKey: "Bubble")
        
        let color = switchColor(isOn).cgColor
        UIView.animate(withDuration: animateDuration, animations: { () -> Void in
            self.lineLayer.fillColor = color
            self.bubbleLayer.fillColor = color
        })
    }
}


// Getter
extension TKLiquidSwitch{
    
    var bubbleSize: CGSize {
        let lineH = 20 * sizeScale
        let w =  lineH * 2 + bounds.height
        let h = bounds.height
        return CGSize(width: w, height: h)
    }

    var bubbleShapePath : CGPath {
        let bubblePath = UIBezierPath()
        let size = bubbleSize
        let sR = (size.width - size.height)/4
        let lR = size.height/2
        
        let l1 = CGPoint(x: sR, y: lR - sR)
        let l2 = CGPoint(x: sR, y: lR + sR)
        
        let c1 = CGPoint(x: sR * 2 + lR, y: 0)
        let c2 = CGPoint(x: sR * 2 + lR, y: lR * 2)
        
        let r1 = CGPoint(x: sR * 3 + lR * 2, y: lR - sR)
        let r2 = CGPoint(x: sR * 3 + lR * 2, y: lR + sR)
        
        let o1 = CGPoint(x: (lR + sR * 2)/4, y: lR - sR)
        let o2 = CGPoint(x: (lR + sR * 2)/4, y: lR + sR)
        let o3 = CGPoint(x: (lR * 2 + sR * 4) - (lR + sR * 2)/4, y: lR - sR)
        let o4 = CGPoint(x: (lR * 2 + sR * 4) - (lR + sR * 2)/4, y: lR + sR)
        
//        let cL = CGPoint(x: sR, y: lR)
        let cC = CGPoint(x: sR * 2 + lR, y: lR)
//        let cR = CGPoint(x: sR * 3 + lR * 2, y: lR)

        bubblePath.move(to: l1)
        bubblePath.addQuadCurve(to: c1, controlPoint: o1)
        bubblePath.addArc(withCenter: cC, radius: lR, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi*3/2, clockwise: true)
        bubblePath.addQuadCurve(to: r1, controlPoint: o3)
        bubblePath.addLine(to: r2)
        
        bubblePath.addQuadCurve(to: c2, controlPoint: o4)
        bubblePath.addQuadCurve(to: l2, controlPoint: o2)
        bubblePath.addLine(to: l1)
        bubblePath.close()
        
        return bubblePath.cgPath
    }
    
    func switchColor(_ isOn: Bool)-> UIColor {
        if isOn{
            return onColor
        }
        else{
            return offColor
        }
    }
    
    func bubblePosition(_ isOn :Bool) -> CGPoint{
        let h = self.bounds.height
        let w = self.bounds.width
        let bW = bubbleSize.width
        
        if isOn{
            return CGPoint(x: bW * 0.8, y: h/2)
        }else{
            return CGPoint(x: w - bW*0.2, y: h/2)
        }
    }
}


