//
//  TKBaseSwitch.swift
//  TKSwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015 TBXark. All rights reserved.
//

import UIKit

/// 动画开关基类.
/// 子类通过重写 `setUpView()` 绘制静止状态, 重写 `animateValueChange(_:duration:)` 播放切换动画.
@IBDesignable
open class TKBaseSwitch: UIControl {

    // MARK: - Property

    /// 用户点击开关时回调, 参数为切换后的新状态.
    /// 通过 `isOn` / `setOn(_:animated:)` 编程式修改不会触发该回调 (与 `UISwitch` 行为一致).
    open var onValueChange: ((Bool) -> Void)?

    /// 切换动画时长
    @IBInspectable open var animationDuration: Double = 0.4

    /// 当前开关状态.
    /// 赋值会立即更新视图 (无动画), 且不触发 `onValueChange` / `UIControl.Event.valueChanged`.
    @IBInspectable open var isOn: Bool {
        get { on }
        set { setOn(newValue, animated: false) }
    }

    private var on = true

    internal var sizeScale: CGFloat {
        min(bounds.width, bounds.height) / 100.0
    }

    open override var frame: CGRect {
        didSet {
            guard frame.size != oldValue.size else {
                return
            }
            resetView()
        }
    }

    open override var bounds: CGRect {
        didSet {
            guard frame.size != oldValue.size else {
                return
            }
            resetView()
        }
    }

    open override var intrinsicContentSize: CGSize {
        CGSize(width: 80, height: 40)
    }

    // MARK: - Getter

    /// 设置开关状态, 可选择是否播放动画.
    /// 与 `UISwitch.setOn(_:animated:)` 一致, 不触发 `onValueChange` 回调和 `UIControl.Event.valueChanged` 事件.
    public func setOn(_ on: Bool, animated: Bool = true) {
        guard on != self.on else {
            return
        }
        self.on = on
        if animated {
            animateValueChange(on, duration: animationDuration)
        } else {
            resetView()
        }
    }

    // MARK: - Init

    convenience public init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        isAccessibilityElement = true
        accessibilityTraits = .button
        setUpView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isAccessibilityElement = true
        accessibilityTraits = .button
        setUpView()
    }

    open override var accessibilityValue: String? {
        get {
            on ? "On" : "Off"
        }
        set {
            super.accessibilityValue = newValue
        }
    }

    override open func accessibilityActivate() -> Bool {
        toggleValue()
        return true
    }

    // MARK: - Internal

    internal func resetView() {
        gestureRecognizers?.forEach(removeGestureRecognizer)
        for sublayer in layer.sublayers ?? [] {
            sublayer.removeFromSuperlayer()
        }
        setUpView()
    }

    internal func setUpView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(TKBaseSwitch.toggleValue))
        addGestureRecognizer(tap)
        for view in subviews {
            view.removeFromSuperview()
        }
    }

    @objc internal func toggleValue() {
        let newValue = !on
        on = newValue
        onValueChange?(newValue)
        sendActions(for: UIControl.Event.valueChanged)
        animateValueChange(newValue, duration: animationDuration)
    }

    internal func animateValueChange(_ value: Bool, duration: Double) {
    }

}
