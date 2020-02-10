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

@IBDesignable
open class TKExchangeSwitch: TKBaseSwitch {

    // MARK: - Property
    private var swichControl: TKExchangeCircleView?
    private var backgroundLayer = CAShapeLayer()

    @IBInspectable open var lineColor = UIColor(white: 0.95, alpha: 1) {
        didSet {
            resetView()
        }
    }

    @IBInspectable open var onColor = UIColor(red: 0.34, green: 0.91, blue: 0.51, alpha: 1.00) {
        didSet {
            resetView()
        }
    }

    @IBInspectable open var offColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00) {
        didSet {
            resetView()
        }
    }

    @IBInspectable open var lineSize: Double = 20 {
        didSet {
            resetView()
        }
    }

    // MARK: - Getter
    var lineWidth: CGFloat {
        return CGFloat(lineSize) * sizeScale
    }

    // MARK: - Init

    // MARK: - Private Func
    override internal func setUpView() {
        super.setUpView()

        let radius = self.bounds.height/2 - lineWidth
        let position = CGPoint(x: radius, y: radius + lineWidth)

        let backLayerPath = UIBezierPath()
        backLayerPath.move(to: CGPoint(x: lineWidth, y: 0))
        backLayerPath.addLine(to: CGPoint(x: bounds.width - 4 * lineWidth, y: 0))

        backgroundLayer.position = position
        backgroundLayer.fillColor = lineColor.cgColor
        backgroundLayer.strokeColor = lineColor.cgColor
        backgroundLayer.lineWidth = self.bounds.height
        backgroundLayer.lineCap = kCALineCapRound
        backgroundLayer.path = backLayerPath.cgPath
        layer.addSublayer(backgroundLayer)

        let swichRadius = bounds.height - lineWidth
        let swichControl = TKExchangeCircleView(frame: CGRect(x: lineWidth/2, y: lineWidth/2, width: swichRadius, height: swichRadius))
        swichControl.onLayer.fillColor = onColor.cgColor
        swichControl.offLayer.fillColor = offColor.cgColor
        addSubview(swichControl)
        self.swichControl = swichControl
    }

    // MARK: - Animate
    override func changeValueAnimate(_ value: Bool, duration: Double) {
        self.on = value
        let keyTimes = [0, 0.4, 0.6, 1]
        guard var frame = self.swichControl?.frame else { return }
        frame.origin.x = value ? lineWidth/2 : (self.bounds.width - self.bounds.height + lineWidth/2)

        let swichControlStrokeStartAnim      = CAKeyframeAnimation(keyPath: "strokeStart")
        swichControlStrokeStartAnim.values   = [0, 0.45, 0.45, 0]
        swichControlStrokeStartAnim.keyTimes = keyTimes as [NSNumber]?
        swichControlStrokeStartAnim.duration = duration
        swichControlStrokeStartAnim.isRemovedOnCompletion = true

        let swichControlStrokeEndAnim      = CAKeyframeAnimation(keyPath: "strokeEnd")
        swichControlStrokeEndAnim.values   = [1, 0.55, 0.55, 1]
        swichControlStrokeEndAnim.keyTimes = keyTimes as [NSNumber]?
        swichControlStrokeEndAnim.duration = duration
        swichControlStrokeEndAnim.isRemovedOnCompletion = true

        let swichControlChangeStateAnim: CAAnimationGroup = CAAnimationGroup()
        swichControlChangeStateAnim.animations = [swichControlStrokeStartAnim, swichControlStrokeEndAnim]
        swichControlChangeStateAnim.fillMode = kCAFillModeForwards
        swichControlChangeStateAnim.isRemovedOnCompletion = false
        swichControlChangeStateAnim.duration = duration

        backgroundLayer.add(swichControlChangeStateAnim, forKey: "SwitchBackground")
        swichControl?.exchangeAnimate(value, duration: duration)

        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.swichControl?.frame = frame
        })
    }
}

// MARK: - Deprecated
extension TKExchangeSwitch {
    @available(*, deprecated, message:"color is deprecated. Use lineColor, onColor, offColor instead ")
    var color: (background: UIColor, on: UIColor, off: UIColor) {
        set {
            if newValue.background != lineColor {
                lineColor = newValue.background
            }
            if newValue.on != onColor {
                onColor = newValue.on
            }
            if newValue.on != offColor {
                offColor = newValue.off
            }
        }
        get {
            return (lineColor, onColor, offColor)
        }
    }
}

private class TKExchangeCircleView: UIView {

    // MARK: - Property
    var onLayer: CAShapeLayer = CAShapeLayer()
    var offLayer: CAShapeLayer = CAShapeLayer()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLayer()
    }

    // MARK: - Private Func
    fileprivate func setUpLayer() {
        let radius = min(self.bounds.width, self.bounds.height)

        offLayer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        offLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius, height: radius)).cgPath
        offLayer.transform = CATransform3DMakeScale(0, 0, 1)
        self.layer.addSublayer(offLayer)

        onLayer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        onLayer.path =  UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius, height: radius)).cgPath
        self.layer.addSublayer(onLayer)
    }

    func exchangeAnimate(_ value: Bool, duration: Double) {

        let fillMode: String = kCAFillModeForwards

        let hideValues = [NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 1)),
                          NSValue(caTransform3D: CATransform3DIdentity)]

        let showValues = [NSValue(caTransform3D: CATransform3DIdentity),
                          NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 1))]

        let showTimingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
        let hideTimingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 1, 1)

        let keyTimes   = [0, 1]

        offLayer.zPosition = value ? 1 : 0
        onLayer.zPosition = value ? 0 : 1

        ////OffLayer animation
        let offLayerTransformAnim            = CAKeyframeAnimation(keyPath: "transform")
        offLayerTransformAnim.values         = value ? hideValues : showValues
        offLayerTransformAnim.keyTimes       = keyTimes as [NSNumber]?
        offLayerTransformAnim.duration       = duration
        offLayerTransformAnim.timingFunction = value ? hideTimingFunction : showTimingFunction
        offLayerTransformAnim.fillMode       = fillMode
        offLayerTransformAnim.isRemovedOnCompletion = false

        ////OnLayer animation
        let onLayerTransformAnim      = CAKeyframeAnimation(keyPath: "transform")
        onLayerTransformAnim.values   = value ? showValues : hideValues
        onLayerTransformAnim.keyTimes = keyTimes as [NSNumber]?
        onLayerTransformAnim.duration = duration
        offLayerTransformAnim.timingFunction = value ? showTimingFunction : hideTimingFunction
        onLayerTransformAnim.fillMode = fillMode
        onLayerTransformAnim.isRemovedOnCompletion = false

        onLayer.add(onLayerTransformAnim, forKey: "OnAnimate")
        offLayer.add(offLayerTransformAnim, forKey: "OffAnimate")
    }

}
