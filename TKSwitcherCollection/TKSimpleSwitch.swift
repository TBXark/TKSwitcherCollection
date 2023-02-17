//
//  TKSimpleSwitch.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit

// Design by Oleg Frolov
//https://dribbble.com/shots/1990516-Switcher
//https://dribbble.com/shots/2165675-Switcher-V

@available(*, deprecated, message: "TKSimpleSwitchConfig is deprecated. ")
public struct TKSimpleSwitchConfig {
    public var onColor: UIColor
    public var offColor: UIColor
    public var lineColor: UIColor
    public var circleColor: UIColor
    public var lineSize: Double

    public init(onColor: UIColor = UIColor(red: 0.341, green: 0.914, blue: 0.506, alpha: 1),
                offColor: UIColor = UIColor(white: 0.9, alpha: 1),
                lineColor: UIColor = UIColor(white: 0.8, alpha: 1),
                circleColor: UIColor = UIColor.white,
                lineSize: Double = 10) {
        self.onColor = onColor
        self.offColor = offColor
        self.lineColor = lineColor
        self.circleColor = circleColor
        self.lineSize = lineSize

    }

}

@IBDesignable
open class TKSimpleSwitch: TKBaseSwitch {

    private var switchControl = CAShapeLayer()
    private var backgroundLayer = CAShapeLayer()

    // 是否加旋转特效
    @IBInspectable open var rotateWhenValueChange: Bool = false

    @IBInspectable open var onColor: UIColor = UIColor(red: 0.341, green: 0.914, blue: 0.506, alpha: 1) {
        didSet {
            resetView()
        }
    }
    @IBInspectable open var offColor: UIColor = UIColor(white: 0.9, alpha: 1) {
        didSet {
            resetView()
        }
    }
    @IBInspectable open var lineColor: UIColor = UIColor(white: 0.8, alpha: 1) {
        didSet {
            resetView()
        }
    }
    @IBInspectable open var circleColor: UIColor = UIColor.white {
        didSet {
            resetView()
        }
    }
    @IBInspectable open var lineSize: Double = 10 {
        didSet {
            resetView()
        }
    }

    private var lineWidth: CGFloat {
        return CGFloat(lineSize) * sizeScale
    }

    // 初始化 View
    override internal func setUpView() {
        super.setUpView()
        self.backgroundColor = UIColor.clear
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let radius = bounds.height / 2 - lineWidth
        let roundedRectPath = UIBezierPath(roundedRect: frame.insetBy(dx: lineWidth, dy: lineWidth), cornerRadius: radius)
        backgroundLayer.fillColor = stateToFillColor(true)
        backgroundLayer.strokeColor = lineColor.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.path = roundedRectPath.cgPath
        layer.addSublayer(backgroundLayer)

        let innerLineWidth = bounds.height - lineWidth * 3 + 1
        let switchControlPath = UIBezierPath()
        switchControlPath.move(to: CGPoint(x: lineWidth, y: 0))
        switchControlPath.addLine(to: CGPoint(x: bounds.width - 2 * lineWidth - innerLineWidth + 1, y: 0))
        var point = backgroundLayer.position
        point.y += (radius + lineWidth)
        point.x += (radius)
        switchControl.position = point
        switchControl.path = switchControlPath.cgPath
        switchControl.lineCap = kCALineCapRound
        switchControl.fillColor = nil
        switchControl.strokeColor = circleColor.cgColor
        switchControl.lineWidth = innerLineWidth
        switchControl.strokeEnd = 0.0001
        layer.addSublayer(switchControl)

    }


    // MARK: - Animate
    override func changeValueAnimate(_ value: Bool, duration: Double) {

        let times = [0, 0.49, 0.51, 1]

        // 线条运动动画
        let switchControlStrokeStartAnim = CAKeyframeAnimation(keyPath: "strokeStart")
        switchControlStrokeStartAnim.values = value ? [1, 0, 0, 0] : [0, 0, 0, 1]
        switchControlStrokeStartAnim.keyTimes = times as [NSNumber]?
        switchControlStrokeStartAnim.duration = duration
        switchControlStrokeStartAnim.isRemovedOnCompletion = true

        let switchControlStrokeEndAnim = CAKeyframeAnimation(keyPath: "strokeEnd")
        switchControlStrokeEndAnim.values = value ? [1, 1, 1, 0] : [0, 1, 1, 1]
        switchControlStrokeEndAnim.keyTimes = times as [NSNumber]?
        switchControlStrokeEndAnim.duration = duration
        switchControlStrokeEndAnim.isRemovedOnCompletion = true

        // 颜色动画
        let backgroundFillColorAnim = CAKeyframeAnimation(keyPath: "fillColor")
        backgroundFillColorAnim.values = [stateToFillColor(!value),
                                          stateToFillColor(!value),
                                          stateToFillColor(value),
                                          stateToFillColor(value)]
        backgroundFillColorAnim.keyTimes = [0, 0.5, 0.51, 1]
        backgroundFillColorAnim.duration = duration
        backgroundFillColorAnim.fillMode = kCAFillModeForwards
        backgroundFillColorAnim.isRemovedOnCompletion = false

        // 旋转动画
        if rotateWhenValueChange {
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.transform = self.transform.rotated(by: CGFloat.pi)
            })
        }

        // 动画组
        let switchControlChangeStateAnim: CAAnimationGroup = CAAnimationGroup()
        switchControlChangeStateAnim.animations = [switchControlStrokeStartAnim, switchControlStrokeEndAnim]
        switchControlChangeStateAnim.fillMode = kCAFillModeForwards
        switchControlChangeStateAnim.isRemovedOnCompletion = false
        switchControlChangeStateAnim.duration = duration

        let animateKey = value ? "value" : "TurnOff"
        switchControl.add(switchControlChangeStateAnim, forKey: animateKey)
        backgroundLayer.add(backgroundFillColorAnim, forKey: "Color")
    }

    private func stateToFillColor(_ isOn: Bool) -> CGColor {
        return isOn ? onColor.cgColor : offColor.cgColor
    }

}

// MARK: - Deprecated
extension TKSimpleSwitch {
    @available(*, deprecated, message: "config is deprecated. Use onColor, offColor, lineColor, circleColor, lineSize instead ")
    open var config: TKSimpleSwitchConfig {
        set {
            if newValue.onColor != onColor {
                onColor = newValue.onColor
            }
            if newValue.offColor != offColor {
                offColor = newValue.offColor
            }
            if newValue.lineColor != lineColor {
                lineColor = newValue.lineColor
            }
            if newValue.circleColor != circleColor {
                lineColor = newValue.lineColor
            }
            if newValue.lineSize != lineSize {
                lineSize = newValue.lineSize
            }
        }
        get {
            return TKSimpleSwitchConfig(onColor: onColor,
                    offColor: offColor,
                    lineColor: lineColor,
                    circleColor: circleColor,
                    lineSize: lineSize)
        }
    }
}
