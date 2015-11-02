//
//  SmileSwitch.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit

// Dedign by Oleg Frolov
//https://dribbble.com/shots/2011284-Switcher-ll



class TKSmileSwitch:  TKMainSwitch{
    
    // MARK: - Poperty
    var smileFace : TKSmileFaceView?
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    
    // MARK: - Init
    override func setUpView(){
        super.setUpView()
        let frame = CGRectMake(0, 0, self.bounds.height, self.bounds.height)
        smileFace = TKSmileFaceView(frame:frame)
        self.addSubview(smileFace!)
        
    }
    
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let lineWidth = 10 * sizeScale
        let path = UIBezierPath(roundedRect: CGRectInset(rect, lineWidth, lineWidth), cornerRadius: rect.width/2)
        CGContextSetLineWidth(ctx, lineWidth*2)
        CGContextAddPath(ctx, path.CGPath)
        UIColor(white: 0.9, alpha: 1).setStroke()
        CGContextStrokePath(ctx)
    }
    
    // MARK: - Private Func
    override func changeValue(){
        super.changeValue()
        let x = isOn ? 0 : (self.bounds.width - self.bounds.height)
        let frame = CGRectMake(x, 0, self.bounds.height, self.bounds.height)
        self.smileFace!.faceType = self.isOn ? TKSmileFaceView.FaceType.happy : TKSmileFaceView.FaceType.sad
        self.smileFace?.rotation(self.animateDuration, count: 2, clockwise: !isOn)
        UIView.animateWithDuration(self.animateDuration, animations: { () -> Void in
            self.smileFace?.frame = frame
            }) { (complete) -> Void in
                if complete{
                    self.smileFace?.eyeWinkAnimate(self.animateDuration/2)
                }
        }
        
    }



}



// 脸
class TKSmileFaceView : UIView {
    
    enum FaceType{
        case happy
        case sad
        func toColor() -> UIColor{
            switch self{
            case .happy:
                return UIColor(red: 0.388, green: 0.839, blue: 0.608, alpha: 1.000)
            case .sad:
                return UIColor(red:0.843,  green:0.369,  blue:0.373, alpha:1)
            }
        }
    }
    

    // MARK: - Property
    let rightEye : CAShapeLayer = CAShapeLayer()
    let leftEye  : CAShapeLayer = CAShapeLayer()
    let mouth    : CAShapeLayer = CAShapeLayer()
    let face     : CAShapeLayer = CAShapeLayer()
    
    var faceType : FaceType = .happy{
        didSet{
            let position : CGFloat = isHappy ? 20*sizeScale : 35*sizeScale
            mouth.path = mouthPath.CGPath
            mouth.frame = CGRectMake(0,position , 60*sizeScale, 20*sizeScale)
            face.fillColor = faceType.toColor().CGColor
        }
    }

    
    // MARK: - Getter
    var isHappy : Bool{
        return (faceType == .happy)
    }
    
    var mouthPath : UIBezierPath {
        get{
            let point : CGFloat = isHappy ? 70*sizeScale : 10
            let path = UIBezierPath()
            path.moveToPoint(CGPointMake(30*sizeScale, 40*sizeScale))
            path.addCurveToPoint(CGPointMake(70*sizeScale, 40*sizeScale), controlPoint1: CGPointMake(30*sizeScale, 40*sizeScale), controlPoint2: CGPointMake(50*sizeScale, point))
            path.lineCapStyle = .Round;
            return path
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupLayers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupLayers()
    }
    
    // MARK: - Private Func
    private func setupLayers(){
        
        let facePath  = UIBezierPath(ovalInRect:CGRectMake(0, 0, 100*sizeScale, 100*sizeScale))
        let eyePath   = UIBezierPath(ovalInRect:CGRectMake(0, 0, 20*sizeScale, 20*sizeScale))

        
        face.frame = CGRectMake(0, 0, 100*sizeScale, 100*sizeScale)
        face.path = facePath.CGPath;
        face.fillColor = faceType.toColor().CGColor
        self.layer.addSublayer(face)
        
        leftEye.frame = CGRectMake(20*sizeScale, 28*sizeScale, 10*sizeScale, 10*sizeScale)
        leftEye.path = eyePath.CGPath;
        leftEye.fillColor = UIColor.whiteColor().CGColor
        self.layer.addSublayer(leftEye)
        
        rightEye.frame = CGRectMake(60*sizeScale, 28*sizeScale, 10*sizeScale, 10*sizeScale)
        rightEye.path = eyePath.CGPath;
        rightEye.fillColor = UIColor.whiteColor().CGColor
        self.layer.addSublayer(rightEye)
        
        mouth.path = mouthPath.CGPath
        mouth.strokeColor = UIColor.whiteColor().CGColor
        mouth.fillColor = UIColor.clearColor().CGColor
        mouth.lineCap = "round"
        mouth.lineWidth = 10*sizeScale
        self.layer.addSublayer(mouth)

        
        faceType = .happy
        
    }
    
    // MARK: - Animate
    func eyeWinkAnimate(duration:Double){
        let eyeleftTransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        eyeleftTransformAnim.values   = [NSValue(CATransform3D: CATransform3DIdentity),
                                         NSValue(CATransform3D: CATransform3DMakeScale(1, 0.1, 1)),
                                         NSValue(CATransform3D: CATransform3DIdentity),
                                        ]
        eyeleftTransformAnim.keyTimes = [0, 0.5,1]
        eyeleftTransformAnim.duration = duration
        leftEye.addAnimation(eyeleftTransformAnim, forKey: "Wink")
        rightEye.addAnimation(eyeleftTransformAnim, forKey: "Wink")
    }
    
    func rotation(duration:Double,count:Int,clockwise:Bool){
        let rotationTransformAnim      = CAKeyframeAnimation(keyPath:"transform.rotation.z")
        rotationTransformAnim.values   = [0,180 * CGFloat(M_PI/180) * CGFloat(count) * (clockwise ? 1 : -1)]
        rotationTransformAnim.keyTimes = [0, 1]
        rotationTransformAnim.removedOnCompletion = false
        rotationTransformAnim.duration = duration
        self.layer.addAnimation(rotationTransformAnim, forKey: "Rotation")
    }

}



