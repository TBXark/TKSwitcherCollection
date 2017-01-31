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



open class TKSmileSwitch:  TKBaseSwitch, TKViewScale {
    
    // MARK: - Poperty
    fileprivate var smileFace : TKSmileFaceView?
    
    
    // MARK: - Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    
    // MARK: - Init
    override internal func setUpView(){
        super.setUpView()
        let frame = CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height)
        smileFace = TKSmileFaceView(frame:frame)
        self.addSubview(smileFace!)
        
    }
    
    override open func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let lineWidth = 10 * sizeScale
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: lineWidth, dy: lineWidth), cornerRadius: rect.width/2)
        ctx?.setLineWidth(lineWidth*2)
        ctx?.addPath(path.cgPath)
        UIColor(white: 0.9, alpha: 1).setStroke()
        ctx?.strokePath()
    }
    
    // MARK: - Private Func
    override public func changeValue(){
        super.changeValue()
        let x = isOn ? 0 : (self.bounds.width - self.bounds.height)
        let frame = CGRect(x: x, y: 0, width: self.bounds.height, height: self.bounds.height)
        self.smileFace!.faceType = self.isOn ? TKSmileFaceView.FaceType.happy : TKSmileFaceView.FaceType.sad
        self.smileFace?.rotation(self.animateDuration, count: 2, clockwise: !isOn)
        UIView.animate(withDuration: self.animateDuration, animations: { () -> Void in
            self.smileFace?.frame = frame
            }, completion: { (complete) -> Void in
                if complete{
                    self.smileFace?.eyeWinkAnimate(self.animateDuration/2)
                }
        }) 
        
    }



}



// 脸
private class TKSmileFaceView : UIView, TKViewScale {
    
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
            mouth.path = mouthPath.cgPath
            mouth.frame = CGRect(x: 0,y: position , width: 60*sizeScale, height: 20*sizeScale)
            face.fillColor = faceType.toColor().cgColor
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
            path.move(to: CGPoint(x: 30*sizeScale, y: 40*sizeScale))
            path.addCurve(to: CGPoint(x: 70*sizeScale, y: 40*sizeScale), controlPoint1: CGPoint(x: 30*sizeScale, y: 40*sizeScale), controlPoint2: CGPoint(x: 50*sizeScale, y: point))
            path.lineCapStyle = .round;
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
    fileprivate func setupLayers(){
        
        let facePath  = UIBezierPath(ovalIn:CGRect(x: 0, y: 0, width: 100*sizeScale, height: 100*sizeScale))
        let eyePath   = UIBezierPath(ovalIn:CGRect(x: 0, y: 0, width: 20*sizeScale, height: 20*sizeScale))

        
        face.frame = CGRect(x: 0, y: 0, width: 100*sizeScale, height: 100*sizeScale)
        face.path = facePath.cgPath;
        face.fillColor = faceType.toColor().cgColor
        self.layer.addSublayer(face)
        
        leftEye.frame = CGRect(x: 20*sizeScale, y: 28*sizeScale, width: 10*sizeScale, height: 10*sizeScale)
        leftEye.path = eyePath.cgPath;
        leftEye.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(leftEye)
        
        rightEye.frame = CGRect(x: 60*sizeScale, y: 28*sizeScale, width: 10*sizeScale, height: 10*sizeScale)
        rightEye.path = eyePath.cgPath;
        rightEye.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(rightEye)
        
        mouth.path = mouthPath.cgPath
        mouth.strokeColor = UIColor.white.cgColor
        mouth.fillColor = UIColor.clear.cgColor
        mouth.lineCap = "round"
        mouth.lineWidth = 10*sizeScale
        self.layer.addSublayer(mouth)

        
        faceType = .happy
        
    }
    
    // MARK: - Animate
    func eyeWinkAnimate(_ duration:Double){
        let eyeleftTransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        eyeleftTransformAnim.values   = [NSValue(caTransform3D: CATransform3DIdentity),
                                         NSValue(caTransform3D: CATransform3DMakeScale(1, 0.1, 1)),
                                         NSValue(caTransform3D: CATransform3DIdentity),
                                        ]
        eyeleftTransformAnim.keyTimes = [0, 0.5,1]
        eyeleftTransformAnim.duration = duration
        leftEye.add(eyeleftTransformAnim, forKey: "Wink")
        rightEye.add(eyeleftTransformAnim, forKey: "Wink")
    }
    
    func rotation(_ duration:Double,count:Int,clockwise:Bool){
        let rotationTransformAnim      = CAKeyframeAnimation(keyPath:"transform.rotation.z")
        rotationTransformAnim.values   = [0,180 * CGFloat(M_PI/180) * CGFloat(count) * (clockwise ? 1 : -1)]
        rotationTransformAnim.keyTimes = [0, 1]
        rotationTransformAnim.isRemovedOnCompletion = false
        rotationTransformAnim.duration = duration
        self.layer.add(rotationTransformAnim, forKey: "Rotation")
    }

}



