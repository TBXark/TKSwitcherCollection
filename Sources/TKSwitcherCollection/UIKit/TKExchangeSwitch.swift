//
//  TKExchangeSwitch.swift
//  TKSwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015 TBXark. All rights reserved.
//

import UIKit

// Design by Oleg Frolov
// https://dribbble.com/shots/2238916-Switcher-VI

@IBDesignable
open class TKExchangeSwitch: TKBaseSwitch {

    // MARK: - Property
    private var switchControl: TKExchangeCircleView?
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
        CGFloat(lineSize) * sizeScale
    }

    // MARK: - Private Func
    override internal func setUpView() {
        super.setUpView()

        let radius = bounds.height / 2 - lineWidth
        let position = CGPoint(x: radius, y: radius + lineWidth)

        let backLayerPath = UIBezierPath()
        backLayerPath.move(to: CGPoint(x: lineWidth, y: 0))
        backLayerPath.addLine(to: CGPoint(x: bounds.width - 4 * lineWidth, y: 0))

        backgroundLayer.position = position
        backgroundLayer.fillColor = lineColor.cgColor
        backgroundLayer.strokeColor = lineColor.cgColor
        backgroundLayer.lineWidth = bounds.height
        backgroundLayer.lineCap = .round
        backgroundLayer.path = backLayerPath.cgPath
        layer.addSublayer(backgroundLayer)

        let switchRadius = bounds.height - lineWidth
        let circleX: CGFloat = isOn ? lineWidth / 2 : (bounds.width - bounds.height + lineWidth / 2)
        let switchControl = TKExchangeCircleView(
            frame: CGRect(x: circleX, y: lineWidth / 2, width: switchRadius, height: switchRadius))
        switchControl.onLayer.fillColor = onColor.cgColor
        switchControl.offLayer.fillColor = offColor.cgColor
        addSubview(switchControl)
        self.switchControl = switchControl
        // 初始状态与动画结束状态保持一致: ON 时显示 onColor 圆钮 (在左), OFF 时显示 offColor 圆钮 (在右)
        switchControl.setSwitchState(isOn)
    }

    // MARK: - Animate
    override func animateValueChange(_ value: Bool, duration: Double) {
        guard let switchControl = switchControl else {
            return
        }
        let keyTimes = [0, 0.4, 0.6, 1]
        var frame = switchControl.frame
        frame.origin.x = value ? lineWidth / 2 : (bounds.width - bounds.height + lineWidth / 2)

        let switchControlStrokeStartAnim = CAKeyframeAnimation(keyPath: "strokeStart")
        switchControlStrokeStartAnim.values = [0, 0.45, 0.45, 0]
        switchControlStrokeStartAnim.keyTimes = keyTimes as [NSNumber]
        switchControlStrokeStartAnim.duration = duration
        switchControlStrokeStartAnim.isRemovedOnCompletion = true

        let switchControlStrokeEndAnim = CAKeyframeAnimation(keyPath: "strokeEnd")
        switchControlStrokeEndAnim.values = [1, 0.55, 0.55, 1]
        switchControlStrokeEndAnim.keyTimes = keyTimes as [NSNumber]
        switchControlStrokeEndAnim.duration = duration
        switchControlStrokeEndAnim.isRemovedOnCompletion = true

        let switchControlChangeStateAnim = CAAnimationGroup()
        switchControlChangeStateAnim.animations = [
            switchControlStrokeStartAnim, switchControlStrokeEndAnim,
        ]
        switchControlChangeStateAnim.fillMode = CAMediaTimingFillMode.forwards
        switchControlChangeStateAnim.isRemovedOnCompletion = false
        switchControlChangeStateAnim.duration = duration

        backgroundLayer.add(switchControlChangeStateAnim, forKey: "SwitchBackground")
        switchControl.exchangeAnimate(value, duration: duration)

        UIView.animate(
            withDuration: duration,
            animations: { () -> Void in
                switchControl.frame = frame
            })
    }
}

private class TKExchangeCircleView: UIView {

    // MARK: - Property
    var onLayer = CAShapeLayer()
    var offLayer = CAShapeLayer()

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
        let radius = min(bounds.width, bounds.height)

        offLayer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        offLayer.path =
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius, height: radius)).cgPath
        self.layer.addSublayer(offLayer)

        onLayer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        onLayer.path =
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius, height: radius)).cgPath
        self.layer.addSublayer(onLayer)
    }

    /// 无动画地设置当前状态: ON 显示 onLayer, OFF 显示 offLayer
    fileprivate func setSwitchState(_ on: Bool) {
        onLayer.zPosition = on ? 1 : 0
        offLayer.zPosition = on ? 0 : 1
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        onLayer.transform = on ? CATransform3DIdentity : CATransform3DMakeScale(0.0001, 0.0001, 1)
        offLayer.transform = on ? CATransform3DMakeScale(0.0001, 0.0001, 1) : CATransform3DIdentity
        CATransaction.commit()
    }

    func exchangeAnimate(_ value: Bool, duration: Double) {

        // 出现: 从 0 放大到原始大小; 消失: 从原始大小缩小到 0
        let showValues = [
            NSValue(caTransform3D: CATransform3DMakeScale(0.0001, 0.0001, 1)),
            NSValue(caTransform3D: CATransform3DIdentity),
        ]
        let hideValues = [
            NSValue(caTransform3D: CATransform3DIdentity),
            NSValue(caTransform3D: CATransform3DMakeScale(0.0001, 0.0001, 1)),
        ]

        let showTimingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
        let hideTimingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 1, 1)

        let keyTimes = [0, 1]

        // ON 时 onLayer 显示在最上层, OFF 时 offLayer 显示在最上层
        onLayer.zPosition = value ? 1 : 0
        offLayer.zPosition = value ? 0 : 1

        ////OnLayer animation
        let onLayerTransformAnim = CAKeyframeAnimation(keyPath: "transform")
        onLayerTransformAnim.values = value ? showValues : hideValues
        onLayerTransformAnim.keyTimes = keyTimes as [NSNumber]
        onLayerTransformAnim.duration = duration
        onLayerTransformAnim.timingFunction = value ? showTimingFunction : hideTimingFunction
        onLayerTransformAnim.fillMode = CAMediaTimingFillMode.forwards
        onLayerTransformAnim.isRemovedOnCompletion = false

        ////OffLayer animation
        let offLayerTransformAnim = CAKeyframeAnimation(keyPath: "transform")
        offLayerTransformAnim.values = value ? hideValues : showValues
        offLayerTransformAnim.keyTimes = keyTimes as [NSNumber]
        offLayerTransformAnim.duration = duration
        offLayerTransformAnim.timingFunction = value ? hideTimingFunction : showTimingFunction
        offLayerTransformAnim.fillMode = CAMediaTimingFillMode.forwards
        offLayerTransformAnim.isRemovedOnCompletion = false

        onLayer.add(onLayerTransformAnim, forKey: "OnAnimate")
        offLayer.add(offLayerTransformAnim, forKey: "OffAnimate")
    }

}
